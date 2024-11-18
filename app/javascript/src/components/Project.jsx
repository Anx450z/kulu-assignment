import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useParams, useNavigate } from 'react-router-dom'
import { Dashboard } from './Dashboard'
import '../styles/project.css'

export const Project = () => {
  const [email, setEmail] = useState('')
  const [role, setRole] = useState('member')
  const [isModalOpen, setIsModalOpen] = useState(false)

  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [userIds, setUserIds] = useState([])
  const [isModal2Open, setIsModal2Open] = useState(false)

  const navigate = useNavigate()

  const { id } = useParams()

  const handleBackdropClick = e => {
    if (e.target === e.currentTarget) {
      setIsModalOpen(false)
      setIsModal2Open(false)
    }
  }

  const getProject = async () => {
    const response = await axios.get(`/api/v1/projects/${id}`)
    return response.data
  }

  const createInvite = async () => {
    const response = await axios.post(`/api/v1/projects/${id}/invites`, {
      email: email,
      role: role,
      project_id: id,
    })
    setIsModalOpen(false)
    setEmail('')
    setRole('member')
  }

  const createTask = async () => {
    const response = await axios.post(`/api/v1/projects/${id}/tasks`, {
      title: title,
      description: description,
      project_id: id,
      user_ids: userIds,
    })
    setIsModal2Open(false)
    setTitle('')
    setDescription('')
    setUserIds([])
    mutate()
    return response
  }

  const getTasks = async () => {
    const response = await axios.get(`/api/v1/projects/${id}/tasks`)
    return response.data
  }

  const { data: project } = useSWR(['project', id], getProject)
  const { data: tasks, isLoading, mutate } = useSWR(['task', id], getTasks)

  return (
    <Dashboard>
      <div className="header">
        <h2>{project?.title}</h2>
        <div className='controls'>
          <button onClick={() => setIsModalOpen(true)} className="create-button">
            Invite user
          </button>
          <button onClick={() => setIsModal2Open(true)} className="create-button">
            Create Task
          </button>
        </div>
      </div>
      <div>
        {isLoading ? (
          <div>Loading tasks...</div>
        ) : (
          <div className='list-container'>
            {tasks.tasks? (
              tasks.tasks.map(task => (
                <div key={task.id} className="project-card" onClick={() => navigate(`/project/${id}/task/${task.id}`)}>
                  <h3>{task.title}</h3>
                  <p>{task.description}</p>
                </div>
              ))
            ) : (
              <div className="empty-state">
                <p>No tasks yet!</p>
              </div>
            )}
          </div>
        )}
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

      {isModal2Open && (
        <div className="modal-backdrop" onClick={handleBackdropClick}>
          <div className="modal">
            <div className="modal-header">
              <h3>Create Task</h3>
              <button onClick={() => setIsModal2Open(false)} className="close-button">
                ×
              </button>
            </div>
            <form onSubmit={createTask}>
              <div className="form-group">
                <input
                  type="text"
                  placeholder="Title"
                  value={title}
                  onChange={e => setTitle(e.target.value)}
                  required
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <input
                  type="text"
                  placeholder="Description"
                  value={description}
                  onChange={e => setDescription(e.target.value)}
                  required
                  className="form-input"
                />
              </div>
              <div className="form-group">
                {project?.members.map(member => (
                  <div key={member.id}>
                    <input
                      type="checkbox"
                      id={member.id}
                      value={member.id}
                      checked={userIds.includes(member.id)}
                      onChange={e => {
                        if (e.target.checked) {
                          setUserIds([...userIds, member.id])
                        } else {
                          setUserIds(userIds.filter(id => id !== member.id))
                        }
                      }}
                    />
                    <label htmlFor={member.id}>{member.email}</label>
                  </div>
                ))}
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  onClick={() => setIsModal2Open(false)}
                  className="cancel-button">
                  Cancel
                </button>
                <button type="submit" className="submit-button">
                  Create Task
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Dashboard>
  )
}
