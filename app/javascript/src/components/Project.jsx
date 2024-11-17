import React, { useState } from 'react'
import '../styles/project.css'
import axios from 'axios'
import useSWR from 'swr'
import { useNavigate, useParams } from 'react-router-dom'

export const Project = () => {
  const { id } = useParams()
  const getProject = async () => {
    const response = await axios.get(`/api/v1/projects/${id}`)
    return response.data
  }


  const { data: project } = useSWR(['project', id], getProject)

  return <>
    <h1>Project</h1>
  </>
}
