import React from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useParams } from 'react-router-dom'
import { Dashboard } from './Dashboard'
import { Comments } from './Comments'
import '../styles/project.css'

export const Task = () => {
  const { taskId } = useParams()

  const getTask = async () => {
    const response = await axios.get(`/api/v1/tasks/${taskId}`)
    console.log('task', response.data)
    return response.data
  }

  const { data: task = {} } = useSWR(['task', taskId], getTask)

  return (
    <Dashboard>
      <div className="list-container">
        <div className="header">
          <h2>{task.task?.title}</h2>
          <p>{task.task?.description}</p>
          {task.task?.users.map(user => (
            <p key={user.id}>{user.email}</p>
          ))}
        </div>
        <Comments />
      </div>
    </Dashboard>
  )
}
