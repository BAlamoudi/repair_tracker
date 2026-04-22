
  function login() {
    //read what the user typed
    var email    = document.getElementById('email').value
    var password = document.getElementById('password').value

    // send to the server
    fetch('/auth/sign_in', {
      method: 'POST',
      headers: {
        //tells the server what kind of data is inn the body.
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ user: { email: email, password: password } })
    })

    //read the response
    .then(function(res) { return res.json() })

    //decide what to do
    //-.then() runs when the server responds. res is the response. 
    //res.json() converts the response text into a javascript object. return passes it to the next .then().
    .then(function(data) {

    // checks if a token came back
      if (data.token) {
        // save the token so other pages can use it
        localStorage.setItem('token', data.token)
        localStorage.setItem('user', JSON.stringify(data.user))

        // send each role to their own page
        if (data.user.role === 'customer') {
          window.location.href = '/customer'
        } else if (data.user.role === 'workshop') {
          window.location.href = '/workshop'
        } else if (data.user.role === 'admin') {
          window.location.href = '/admin'
        }

      } else {
        // show the error box
        document.getElementById('error-box').style.display = 'block'
      }

    })
  }