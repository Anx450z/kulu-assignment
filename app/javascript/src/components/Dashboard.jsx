import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/auth'
import { Projects } from './Projects'
import axios from 'axios'
import useSWR from 'swr'
import '../styles/auth.css'

export const Dashboard = () => {
  const navigate = useNavigate()
  const [isModalOpen, setIsModalOpen] = useState(false)

  const handleLogout = () => {
    authService.logout()
    navigate('/login')
  }

  const email = localStorage.getItem('authEmail')

  const getInvites = async () => {
    const response = await axios.get(`/api/v1/invites`)
    return response.data
  }

  const handleAccept = async inviteId => {
    try {
      await axios.post(`/api/v1/invites/${inviteId}/accept`)
      mutate()
    } catch (error) {
      console.error('Error accepting invite:', error)
    }
  }

  const handleDecline = async inviteId => {
    try {
      await axios.post(`/api/v1/invites/${inviteId}/decline`)
      mutate()
    } catch (error) {
      console.error('Error declining invite:', error)
    }
  }

  const { data: invites = [], isLoading, mutate } = useSWR('/api/v1/invites', getInvites)

  return (
    <div>
      <nav className="nav-bar">
        <h1>Dashboard</h1>
        <p onClick={() => navigate('/dashboard')}>all projects</p>
        <div className="invite-section">
          <button className="invite-button" onClick={() => setIsModalOpen(true)}>
            Invites ({invites.invites?.length || 0})
          </button>
        </div>
        <p>{email}</p>
        <button onClick={handleLogout} className="logout-button">
          Logout
        </button>
      </nav>

      {isModalOpen && (
        <div
          className="modal-backdrop"
          onClick={e => {
            if (e.target === e.currentTarget) setIsModalOpen(false)
          }}>
          <div className="modal">
            <div className="modal-header">
              <h2>Project Invites</h2>
              <button className="close-button" onClick={() => setIsModalOpen(false)}>
                ×
              </button>
            </div>
            <div className="invites-list">
              {invites.invites?.map(invite => (
                <div key={invite.id} className="invite-item">
                  <div className="invite-info">
                    <h3>{invite.project.title}</h3>
                    <p>{invite.project.description}</p>
                    <p>Owner: {invite.project.owner.email}</p>
                  </div>
                  <div className="invite-actions">
                    <button className="accept-button" onClick={() => handleAccept(invite.id)}>
                      Accept
                    </button>
                    <button className="decline-button" onClick={() => handleDecline(invite.id)}>
                      Decline
                    </button>
                  </div>
                </div>
              ))}
              {invites?.length === 0 && <p className="no-invites">No pending invites</p>}
            </div>
          </div>
        </div>
      )}

      <div className="dashboard-container">
        <Projects />
      </div>
    </div>
  )
}
