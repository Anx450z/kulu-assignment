import React, { useState } from 'react'
import '../styles/project.css'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate, useParams } from 'react-router-dom'
import { Dashboard } from './Dashboard'

export const Project = () => {
  const { id } = useParams()
  const getProject = async () => {
    const response = await axios.get(`/api/v1/projects/${id}`)
    return response.data
  }


  const { data: project } = useSWR(['project', id], getProject)

  return <Dashboard>
    <h1>Project</h1>
  </Dashboard>
}
