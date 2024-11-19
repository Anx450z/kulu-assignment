import React from 'react'
import { authService } from '../services/auth'
import '../styles/auth.css'

const GoogleLogin = () => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''

  return (
    <div className="login-container">
      <form method="post" action={`/users/auth/google_oauth2?type=signup`} >
      <input type="hidden" name="authenticity_token" value={csrfToken} />
      <div>
        <h1>Assignment: Project management</h1>
        <br />
        <h2>By: <a href="https://github.com/Anx450z">Ankur Singh Chauhan</a></h2>
        <h3>Source Code: <a href="https://github.com/Anx450z/kulu-assignment">Github</a></h3>
      </div>
      <br />
      <p>Begin by logging in</p>
      <button
          type="submit"
          className="google-login-button"
        >Login with Google &gt;</button>
      </form>
    </div>
  )
}

export default GoogleLogin
