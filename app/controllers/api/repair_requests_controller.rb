class Api::RepairRequestsController < ApplicationController

    # GET /api/repair_requests
    def index
      #case is like switch
      requests = case current_user.role
      when 'customer'
        # only requests where they are the customer
        RepairRequest.where(customer_id: current_user.id)
      when 'workshop'
        # submitted requests waiting for review
        # or requests this specific workshop already quoted
        RepairRequest.where(status: 'submitted')
                     .or(RepairRequest.where(workshop_id: current_user.id))
      when 'admin'
        # everything
        RepairRequest.all
      end
    
      render json: requests
    end
  
    # POST /api/repair_requests
    def create
      # Only customers can create requests
      unless current_user.role == 'customer'
        return render json: { error: 'Only customers can create requests' }, status: :forbidden
      end
  
      request = RepairRequest.new(
        vehicle_details: params[:vehicle_details],
        problem_description: params[:problem_description],
        status: 'submitted',
        customer_id: current_user.id
      )
  
      if request.save
        log_action(request, 'submitted', nil, 'submitted')
        render json: request, status: :created
      else
        render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # POST /api/repair_requests/:id/quote
    def quote
      # Only workshops can quote
      unless current_user.role == 'workshop'
        return render json: { error: 'Only workshops can quote' }, status: :forbidden
      end
  
      repair_request = RepairRequest.find(params[:id])
  
      # Must be in 'submitted' status to be quoted
      unless repair_request.status == 'submitted'
        return render json: { error: "Cannot quote a request with status: #{repair_request.status}" }, status: :unprocessable_entity
      end
  
      old_status = repair_request.status
  
      repair_request.update!(
        status: 'quoted',
        price_quotation: params[:price_quotation],
        workshop_id: current_user.id
      )
  
      log_action(repair_request, 'quoted', old_status, 'quoted')
      render json: repair_request
    end
  
    # POST /api/repair_requests/:id/approve
    def approve
      admin_transition('approved')
    end
  
    # POST /api/repair_requests/:id/reject
    def reject
      admin_transition('rejected')
    end
  
    private
  
    # Reusable method for approve and reject since they work the same way
    def admin_transition(new_status)
      unless current_user.role == 'admin'
        return render json: { error: 'Only admins can do this' }, status: :forbidden
      end
  
      repair_request = RepairRequest.find(params[:id])
  
      # Can only approve or reject a quoted request
      unless repair_request.status == 'quoted'
        return render json: { error: "Cannot #{new_status} a request with status: #{repair_request.status}" }, status: :unprocessable_entity
      end
  
      old_status = repair_request.status
      repair_request.update!(status: new_status)
  
      log_action(repair_request, new_status, old_status, new_status)
      render json: repair_request
    end
  
    # Records every status change in the audit log
    def log_action(repair_request, action, from_status, to_status)
      AuditLog.create!(
        repair_request_id: repair_request.id,
        user_id: current_user.id,
        action: action,
        from_status: from_status,
        to_status: to_status
      )
    end
  
  end