import React from 'react'
import { authService } from '../services/auth'
import '../styles/auth.css'

const GoogleLogin = () => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''

  return (
    <div className="login-container">
      <form method="post" action={`/users/auth/google_oauth2?type=signup`} >
      <input type="hidden" name="authenticity_token" value={csrfToken} />
      <button
          type="submit"
          className="google-login-button"
        >Signup</button>
      </form>
    </div>
  )
}

export default GoogleLogin
