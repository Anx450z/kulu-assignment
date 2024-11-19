import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate, useParams } from 'react-router-dom'
import { Dashboard } from './Dashboard'
import { Comments } from './Comments'
import '../styles/project.css'

export const Task = () => {
  // const [userId, setUserId] = useState('')
  const { taskId } = useParams()
  const navigate = useNavigate()

  const getTask = async () => {
    const response = await axios.get(`/api/v1/tasks/${taskId}`)
    console.log(response.data)
    return response.data
  }

  const assignUser = async userId => {
    const response = await axios.patch(`/api/v1/tasks/${taskId}/assign_user`, {
      user_id: userId,
    })
    mutate()
    return response.data
  }

  const unassignUser = async userId => {
    const response = await axios.patch(`/api/v1/tasks/${taskId}/unassign_user`, {
      user_id: userId,
    })
    mutate()
    return response.data
  }

  const { data: task = {}, mutate } = useSWR(['task', taskId], getTask)

  return (
    <Dashboard>
      <h3 className="breadcrumb-container">
        <p className="breadcrumb" onClick={() => navigate(`/`)}>All Projects</p><p>&lt;</p>
        <p className="breadcrumb" onClick={() => navigate(`/project/${task.project?.id}`)}>{task.project?.title}</p><p>&lt;</p>
        <p className="breadcrumb">{task.task?.title}</p>
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
            <div className="sidebar-controls" key={member.id}>
              <p>{member.email}</p>
              <button className="cancel-button" onClick={() => unassignUser(member.id)}>
                Remove
              </button>
            </div>
          ))}
          <br />
          <h3>Project Members</h3>
          {task.project_members?.map(member => (
            <div className="sidebar-controls" key={member.id}>
              <p>{member.email}</p>
              <button className="cancel-button" onClick={() => assignUser(member.id)}>
                Add
              </button>
            </div>
          ))}
        </div>
      </div>
    </Dashboard>
  )
}
