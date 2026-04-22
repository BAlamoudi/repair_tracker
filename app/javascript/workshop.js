
  // ── get token from localStorage ──
  var token = localStorage.getItem('token')
  var user  = JSON.parse(localStorage.getItem('user'))

  // ── if not logged in go to login ──
  if (!token) { window.location.href = '/' }

  // ── if wrong role go to login ──
  if (user.role !== 'workshop') { window.location.href = '/' }

  // ────────────────────────────────
  // GET CSRF TOKEN
  function getCSRF() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }

  // ────────────────────────────────
  // SHOW A MESSAGE
  function showMessage(text, type) {
    var box = document.getElementById('page-message')
    box.textContent = text
    box.className = 'message ' + type
    box.style.display = 'block'
    setTimeout(function() { box.style.display = 'none' }, 4000)
  }

  // ────────────────────────────────
  // LOAD REQUESTS
  function loadRequests() {
    fetch('/api/repair_requests', {
      headers: { 'Authorization': token }
    })
    .then(function(res) { return res.json() })
    .then(function(requests) {

      if (requests.length === 0) {
        document.getElementById('requests-area').innerHTML =
          '<p class="empty">No requests available.</p>'
        return
      }

      // build table rows
      var rows = ''
      for (var i = 0; i < requests.length; i++) {
        var r = requests[i]

        // only show quote button on submitted requests
        var actions = '—'
        if (r.status === 'submitted') {
          actions =
            '<input class="price" type="number" id="price-' + r.id + '" placeholder="Price">' +
            '<button class="quote-btn" onclick="submitQuote(' + r.id + ')">Quote</button>'
        }

        rows += '<tr>' +
          '<td>#' + r.id + '</td>' +
          '<td>' + r.vehicle_details + '</td>' +
          '<td>' + r.problem_description + '</td>' +
          '<td><span class="badge ' + r.status + '">' + r.status + '</span></td>' +
          '<td>' + (r.price_quotation ? '$' + r.price_quotation : '—') + '</td>' +
          '<td>' + actions + '</td>' +
        '</tr>'
      }

      document.getElementById('requests-area').innerHTML =
        '<table>' +
          '<tr><th>ID</th><th>Vehicle</th><th>Problem</th><th>Status</th><th>Price</th><th>Action</th></tr>' +
          rows +
        '</table>'
    })
  }

  // ────────────────────────────────
  // SUBMIT A QUOTE
  function submitQuote(id) {
    var price = document.getElementById('price-' + id).value

    // check price is filled
    if (price === '') {
      showMessage('Please enter a price first', 'error')
      return
    }

    // send to server
    fetch('/api/repair_requests/' + id + '/quote', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
        'X-CSRF-Token': getCSRF()
      },
      body: JSON.stringify({ price_quotation: price })
    })
    .then(function(res) { return res.json() })
    .then(function(data) {
      if (data.status === 'quoted') {
        showMessage('Quote submitted successfully!', 'success')
        loadRequests()
      } else {
        showMessage(data.error || 'Something went wrong', 'error')
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
