import {React, useState} from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useParams } from 'react-router-dom'
import '../styles/project.css'

export const Comments = () => {
  const [comment, setComment] = useState('')
  const { id } = useParams()

  const getComments = async () => {
    const response = await axios.get(`/api/v1/tasks/${id}/comments`)
    mutate()
    return response.data
  }

  const createComment = async () => {
    const response = await axios.post(`/api/v1/tasks/${id}/comments`, {
      body: comment,
    })
    return response.data
  }

  const likeComment = async (commentId) => {
    const response = await axios.post(`/api/v1/comments/${commentId}/like`)
    mutate()
    return response.data
  }

  const deleteComment = async (commentId) => {
    const response = await axios.delete(`/api/v1/comments/${commentId}`)
    mutate()
    return response.data
  }

  const { data: comments = [], mutate, isLoading } = useSWR(['comments', id], getComments)

  return (
    <div className='header'>
      {/* should have text area */}
      {/* should have button to add comment */}
      {/* should have list of comments */}
    </div>
  )
}
