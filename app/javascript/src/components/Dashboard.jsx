import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/auth'
import axios from 'axios'
import useSWR from 'swr'
import { Invite } from './Invite'
import '../styles/auth.css'

export const Dashboard = ({ children }) => {
  const navigate = useNavigate()
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [inviteCount, setInviteCount] = useState(0)

  const handleLogout = () => {
    authService.logout()
    navigate('/login')
  }

  const getInvites = async () => {
    const response = await axios.get(`/api/v1/invites`)
    setInviteCount(response.data.invites.length || 0)
    return response.data
  }

  const { data: invites = [], mutate } = useSWR('/api/v1/invites', getInvites)

  const email = localStorage.getItem('authEmail')

  return (
    <div>
      <nav className="nav-bar">
        <h1>Dashboard</h1>
        <p onClick={() => navigate('/')}>all projects</p>
        <div className="invite-section">
          <span className="invite-button" onClick={() => setIsModalOpen(true)}>
            Invites ({inviteCount || 0})
          </span>
        </div>
        <p>{email}</p>
        <button onClick={handleLogout} className="logout-button">
          Logout
        </button>
      </nav>
      {isModalOpen && (
        <Invite
          isModelOpen={isModalOpen}
          setIsModalOpen={setIsModalOpen}
          setInviteCount={setInviteCount}
          mutate={mutate}
          invites={invites.invites}
        />
      )}
      <div className="dashboard-container">
        {children}
      </div>
    </div>
  )
}
