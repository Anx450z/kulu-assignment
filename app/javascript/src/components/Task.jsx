import React from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate, useParams } from 'react-router-dom'
import { Dashboard } from './Dashboard'
import { Comments } from './Comments'
import '../styles/project.css'

export const Task = () => {
  const { taskId } = useParams()
  const navigate = useNavigate()

  const getTask = async () => {
    const response = await axios.get(`/api/v1/tasks/${taskId}`)
    return response.data
  }

  const { data: task = {} } = useSWR(['task', taskId], getTask)

  return (
    <Dashboard>
      <h3
        style={{ cursor: 'pointer', color: 'gray' }}
        onClick={() => navigate(`/project/${task.project?.id}`)}>
        &lt; {task.project?.title}
      </h3>

      <div className="project-member-container">
        <div className="list-container">
          <div className="header-container">
            <h2>Task: {task.task?.title}</h2>
            <p>
              <strong>Description: {task.task?.description}</strong>
            </p>
          </div>
          <Comments taskId={taskId} />
        </div>
        <div className="project-members">
          <h3>Task Members</h3>
          {task.task?.users?.map(member => (
            <div key={member.id}>
              <p>{member.email}</p>
            </div>
          ))}
        </div>
      </div>
    </Dashboard>
  )
}
