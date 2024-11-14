import React from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/auth'
import '../styles/auth.css'

export const Dashboard = () => {
  const navigate = useNavigate()

  const handleLogout = () => {
    authService.removeToken()
    navigate('/login')
  }

  return (
    <div>
      <nav className="nav-bar">
        <h1>Dashboard</h1>
        <button onClick={handleLogout} className="logout-button">
          Logout
        </button>
      </nav>
      <div className="dashboard-container">{/* Your dashboard content here */}</div>
    </div>
  )
}
