import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate, useParams } from 'react-router-dom'
import { Dashboard } from './Dashboard'
import '../styles/project.css'

export const Project = () => {
  const [email, setEmail] = useState('')
  const [role, setRole] = useState('member')
  const [isModalOpen, setIsModalOpen] = useState(false)

  const { id } = useParams()

  const handleBackdropClick = e => {
    if (e.target === e.currentTarget) {
      setIsModalOpen(false)
    }
  }

  const getProject = async () => {
    const response = await axios.get(`/api/v1/projects/${id}`)
    console.log(response.data)
    return response.data
  }

  const createInvite = async () => {
    console.log(email, role, id)
    const response = await axios.post(`/api/v1/projects/${id}/invites`, {
      email: email,
      role: role,
      project_id: id
    })
    setIsModalOpen(false)
    setEmail('')
    setRole('member')
  }

  const { data: project } = useSWR(['project', id], getProject)

  return (
    <Dashboard>
      <div className="header">
        <h2>{project?.title}</h2>
        <button onClick={() => setIsModalOpen(true)} className="create-button">
          Invite user
        </button>
      </div>
      {isModalOpen && (
        <div className="modal-backdrop" onClick={handleBackdropClick}>
          <div className="modal">
            <div className="modal-header">
              <h3>Invite User</h3>
              <button onClick={() => setIsModalOpen(false)} className="close-button">
                ×
              </button>
            </div>
            <form onSubmit={createInvite}>
              <div className="form-group">
                <input
                  type="text"
                  placeholder="user@email.com"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  required
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <select
                  value={role}
                  onChange={e => setRole(e.target.value)}
                  required
                  className="form-input">
                  <option value="member">Member</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="cancel-button">
                  Cancel
                </button>
                <button type="submit" className="submit-button">
                  Send Invite
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Dashboard>
  )
}
