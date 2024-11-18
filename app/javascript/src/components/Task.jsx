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
    console.log(response.data.project.title)
    return response.data
  }

  const { data: task = {} } = useSWR(['task', taskId], getTask)

  return (
    <Dashboard>
      <h3 style={{ cursor: 'pointer', color: 'gray' }} onClick={() => navigate(`/project/${task.project?.id}`)}>
        Back to {task.project?.title}
      </h3>
      <div className="list-container">
        <div className="header">
          <h2>{task.task?.title}</h2>
          <p>
            <strong>{task.task?.description}</strong>
          </p>
          {task.task?.users.map(user => (
            <p key={user.id}>{user.email}</p>
          ))}
        </div>
        <Comments taskId={taskId} />
      </div>
    </Dashboard>
  )
}
