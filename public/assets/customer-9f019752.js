
  //  get token and user from localStorage 
  var token = localStorage.getItem('token')
  var user  = JSON.parse(localStorage.getItem('user'))

  // - if not logged in send back to login 
  if (!token) {
    window.location.href = '/'
  }

  // - if wrong role send back to login 
  if (user.role !== 'customer') {
    window.location.href = '/'
  }

  // ────────────────────────────────
  // SHOW A MESSAGE (success or error)
  function showMessage(text, type) {
    var box = document.getElementById('form-message')
    box.textContent = text
    box.className = 'message ' + type
    box.style.display = 'block'
    setTimeout(function() { box.style.display = 'none' }, 4000)
  }

  // ────────────────────────────────
  // GET CSRF TOKEN FROM THE PAGE
  function getCSRF() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }

  // ────────────────────────────────
  // LOAD AND SHOW MY REQUESTS
  function loadRequests() {
    fetch('/api/repair_requests', {
      headers: { 'Authorization': token }
    })
    .then(function(res) { return res.json() })
    .then(function(requests) {

      // if no requests show empty message
      if (requests.length === 0) {
        document.getElementById('requests-area').innerHTML =
          '<p class="empty">No requests yet.</p>'
        return
      }

      // build the table rows
      var rows = ''
      for (var i = 0; i < requests.length; i++) {
        var r = requests[i]
        rows += '<tr>' +
          '<td>#' + r.id + '</td>' +
          '<td>' + r.vehicle_details + '</td>' +
          '<td>' + r.problem_description + '</td>' +
          '<td><span class="badge ' + r.status + '">' + r.status + '</span></td>' +
          '<td>' + (r.price_quotation ? '$' + r.price_quotation : '—') + '</td>' +
        '</tr>'
      }

      // put the table on the page
      document.getElementById('requests-area').innerHTML =
        '<table>' +
          '<tr><th>ID</th><th>Vehicle</th><th>Problem</th><th>Status</th><th>Price</th></tr>' +
          rows +
        '</table>'
    })
  }

  // ────────────────────────────────
  // SUBMIT A NEW REQUEST
  function submitRequest() {
    var vehicle = document.getElementById('vehicle').value
    var problem = document.getElementById('problem').value

    // check fields are filled
    if (vehicle === '' || problem === '') {
      showMessage('Please fill in all fields', 'error')
      return
    }

    // send to server
    fetch('/api/repair_requests', {
      method: 'POST',
      headers: {
        //tells the server what kind of data is inn the body.
        'Content-Type': 'application/json',
        'Authorization': token,
        'X-CSRF-Token': getCSRF()
      },
      body: JSON.stringify({
        vehicle_details: vehicle,
        problem_description: problem
      })
    })
    .then(function(res) { return res.json() })
    .then(function(data) {
      if (data.id) {
        // clear the form
        document.getElementById('vehicle').value = ''
        document.getElementById('problem').value = ''
        //show success
        showMessage('Request submitted successfully!', 'success')
        //reload the table
        loadRequests()
      } else {
        showMessage('Something went wrong. Try again.', 'error')
      }
    })
  }

  // ────────────────────────────────
  // LOGOUT
  function logout() {
    fetch('/auth/sign_out', {
      method: 'DELETE',
      headers: {
        'Authorization': token,
        'X-CSRF-Token': getCSRF()
      }
    })
    .then(function() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/'
    })
  }

  // ── load requests when page opens ──
  loadRequests()
