# README


## Tech Stack

- **Ruby on Rails 8** — backend framework
- **SQLite** — database
- **Devise + JWT** — authentication
- **HTML + CSS + JavaScript** — frontend UI

## Setup Instructions

### 1. Open terminal on your IDE 

### 2. Clone the project
```bash
git clone https://github.com/YOUR_USERNAME/repair_tracker.git
cd repair_tracker
```

### 2. Install dependencies
```bash
bundle install
```

### 3. Set up the database
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

### 4. Start the server
```bash
bin/rails server
```

### 5. Open Your Browser
go to http://127.0.0.1:3000

--------------------------------------------------------------

## Users

After running `bin/rails db:seed` these users are available:

1- Customer <- Rule, customer@test.com <- Email, password123 <- Password

2- Workshop <- Rule, workshop@test.com <- Email, password123 <- Password

3- Admin <- Rule, admin@test.com <- Email, password123 <- Password

## Using UI

1. go to http://127.0.0.1:3000 in your browser
2. Login with any user each one of them has their own dashboard:
   - Customer : Submit requests, view their status
   - Workshop : View Submitted Requests, and add price quotes
   - Admin : approve or reject quoted requests

## Using API

All endpoints use JSON. Authentication uses JWT tokens.

### 1. Authentication Login

POST /auth/sign_in
Content-Type: application/json
{
    "user": {
    "email": "customer@test.com",
    "password": "password123"
    }
}

### 2. Authentication Logout

Delete /auth/sign_out
Authorization: Bearer "YOUR_TOKEN"

### 3. Customer create a repair request

POST /api/repair_requests
Authorization: Bearer "YOUR_TOKEN"
Content-Type: application/json
{
    "vehicle_details": "Toyota Camry",
    "problem_description": "Engine makes noise"
}

### 4. Customer list requests

GET /api/repair_requests
Authorization: Bearer "YOUR_TOKEN"

### 5. Workshop submit a quote

POST /api/repair_requests/:id/quote
Authorization: Bearer "YOUR_TOKEN"
Content-Type: application/json
{
    "price_quotation": 500
}

### 6. Workshop list requests

GET /api/repair_requests
Authorization: Bearer "YOUR_TOKEN"

### 7. Admin approve a request

POST /api/repair_requests/":id"/approve
Authorization: Bearer "YOUR_TOKEN"

### 8. Admin reject a request

POST /api/repair_requests/":id"/reject
Authorization: Bearer "YOUR_TOKEN"

### 9. Admin list requests

GET /api/repair_requests
Authorization: Bearer "YOUR_TOKEN"

--------------------------------------------------------------

## Request Lifecycle

     Customer submit Request
                |
            submitted
                |
      Workshop Adds a quote
                |
             quoted
                |
      Admin approves/rejects
                |
        approved/rejected



Rules:
- Cannot skip steps
- Cannot approve before quoting
- Cannot quote an already quoted request 
- Cannot approve/reject an already approved/rejected request 


--------------------------------------------------------------

## Audit Log

Every status change is recorded and we can view it through rails console:

```ruby
bin/rails console

# See all changes
AuditLog.all

```

--------------------------------------------------------------

