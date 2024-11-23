import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/auth'
import axios from 'axios'
import useSWR from 'swr'
import { Invite } from './Invite'
import { saveTheme } from '../services/theme'
import '../styles/auth.css'

export const Dashboard = ({ children }) => {
  const navigate = useNavigate()
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [inviteCount, setInviteCount] = useState(0)
  const [theme, setTheme] = useState(localStorage.getItem('theme') || 'light')

  const handleThemeChange = () => {
    if (theme === 'light') {
      saveTheme('dark')
      setTheme('dark')
    } else {
      saveTheme('light')
      setTheme('light')
    }
    window.location.reload()
  }

  const handleLogout = () => {
    authService.logout()
    navigate('/login')
  }

  const getInvites = async () => {
    const response = await axios.get(`/api/v1/invites`)
    setInviteCount(response.data.invites.length || 0)
    return response.data
  }

  const { data: invites = [], mutate } = useSWR('/api/v1/invites', getInvites, { revalidateOnFocus: true, revalidateOnMount: false, refreshInterval:30000})

  const email = localStorage.getItem('authEmail')

  return (
    <div>
      <nav className="nav-bar">
        <h1>Dashboard</h1>
        <div className="controls">
          <p className="link" onClick={() => navigate('/')}>
            All projects
          </p>
          <p>|</p>
          <div className="invite-section">
            <span className="invite-button link" onClick={() => setIsModalOpen(true)}>
              Invites ({inviteCount || 0})
            </span>
          </div>
        </div>
        <div className="controls">
          <button className="cancel-button" onClick={handleThemeChange}>
            Change theme
          </button>
          <p>{email}</p>
          <button onClick={handleLogout} className="logout-button">
            Logout
          </button>
        </div>
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
      <div className="dashboard-container">{children}</div>
      <div className='footer'>
        <br />
        <p>This is a demo project by: <a href="https://github.com/Anx450z">Ankur Singh Chauhan</a></p>
        <p>Source Code: <a href="https://github.com/Anx450z/kulu-assignment">Github</a></p>
      </div>
    </div>
  )
}
