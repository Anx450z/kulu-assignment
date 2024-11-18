import React, { useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { setToLocalStorage } from '../services/storage'
import '../styles/auth.css'

const AuthCallback = () => {
  const navigate = useNavigate()
  const location = useLocation()

  useEffect(() => {
    const params = new URLSearchParams(location.search)
    const token = params.get('token')
    const email = params.get('email')
    const error = params.get('error')

    if (token) {
      setToLocalStorage(token, email)
      navigate('/')
    } else if (error) {
      navigate('/login', { state: { error } })
    } else {
      navigate('/login')
    }
  }, [navigate, location])

  return (
    <div className="loading-container">
      <div className="loading-spinner"></div>
    </div>
  )
}

export default AuthCallback
