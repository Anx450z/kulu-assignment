import React from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/auth'
import { Projects } from './Projects'
import axios from 'axios'
import useSWR from 'swr'
import '../styles/auth.css'

export const Dashboard = () => {
  const navigate = useNavigate()

  const handleLogout = () => {
    authService.logout()
    navigate('/login')
  }
  const email = localStorage.getItem('authEmail')

  const getInvites = async () => {
    const response = await axios.get(`/api/v1/invites`)
    return response.data
  }

  const { data: invites, isLoading, mutate } = useSWR('/api/v1/invites', getInvites)

  return (
    <div>
      <nav className="nav-bar">
        <h1>Dashboard</h1>
        <p onClick={() => navigate('/dashboard')}>all projects</p>
        <p>{email}</p>
        <p>{console.log(invites)}</p>
        <button onClick={handleLogout} className="logout-button">
          Logout
        </button>
      </nav>
      <div className="dashboard-container"><Projects /></div>
    </div>
  )
}
