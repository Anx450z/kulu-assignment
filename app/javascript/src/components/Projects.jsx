import React, { useState } from 'react'
import '../styles/project.css'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate } from 'react-router-dom'
import { Dashboard } from './Dashboard'

export const Projects = () => {
  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [isModalOpen, setIsModalOpen] = useState(false)
  const navigate = useNavigate()

  const getProjects = async () => {
    const response = await axios.get('/api/v1/projects')
    return response.data
  }

  const createProject = async e => {
    try {
      const response = await axios.post('/api/v1/projects', {
        title,
        description,
      })
      setTitle('')
      setDescription('')
      setIsModalOpen(false)
      mutate()
    } catch (error) {
      console.error('Error creating project:', error)
    }
  }

  const { data: projects = [], isLoading, mutate } = useSWR('/api/v1/projects', getProjects, { revalidateOnFocus: false})

  const handleBackdropClick = e => {
    if (e.target === e.currentTarget) {
      setIsModalOpen(false)
    }
  }

  return (
      <Dashboard>
      <div className="header">
        <h2>All Projects</h2>
        <button onClick={() => setIsModalOpen(true)} className="create-button">
          Create New Project
        </button>
      </div>

      <div>
        {isLoading ? (
          <div>Loading projects...</div>
        ) : (
          <div className='list-container'>
            {projects.projects? (
              projects.projects.map(project => (
                <div key={project.id} className="project-card" onClick={() => navigate(`/project/${project.id}`)}>
                  <h3>{project.title}</h3>
                  <p>{project.description}</p>
                </div>
              ))
            ) : (
              <div className="empty-state">
                <p>No projects yet!</p>
              </div>
            )}
          </div>
        )}
      </div>

      {isModalOpen && (
        <div className="modal-backdrop" onClick={handleBackdropClick}>
          <div className="modal">
            <div className="modal-header">
              <h3>Create New Project</h3>
              <button onClick={() => setIsModalOpen(false)} className="close-button">
                ×
              </button>
            </div>
            <form onSubmit={createProject}>
              <div className="form-group">
                <input
                  type="text"
                  placeholder="Project Title"
                  value={title}
                  onChange={e => setTitle(e.target.value)}
                  required
                  className="form-input"
                />
              </div>
              <div className="form-group">
                <textarea
                  placeholder="Project Description"
                  value={description}
                  onChange={e => setDescription(e.target.value)}
                  required
                  className="form-textarea"
                />
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="cancel-button">
                  Cancel
                </button>
                <button type="submit" className="submit-button">
                  Create Project
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </Dashboard>
  )
}

export default Projects
