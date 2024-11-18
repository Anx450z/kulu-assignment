import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import { useParams } from 'react-router-dom'
import '../styles/project.css'

export const Comments = (props) => {
  const [comment, setComment] = useState('')
  const { id } = useParams()

  const getComments = async () => {
    const response = await axios.get(`/api/v1/task/${props.taskId}/comments`)
    console.log(response.data)
    return response.data
  }

  const createComment = async () => {
    if (!comment.trim()) return
    await axios.post(`/api/v1/task/${props.taskId}/comments`, {
      body: comment,
    })
    setComment('')
    mutate()
  }

  const likeComment = async commentId => {
    await axios.post(`/api/v1/comments/${commentId}/like`)
    mutate()
  }

  const deleteComment = async commentId => {
    await axios.delete(`/api/v1/comments/${commentId}`)
    mutate()
  }

  const { data: comments = [], mutate, isLoading } = useSWR(['comments', id], getComments)

  const handleSubmit = e => {
    e.preventDefault()
    createComment()
  }

  return (
    <div className="header">
      <div className="modal">
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <textarea
              value={comment}
              onChange={e => setComment(e.target.value)}
              placeholder="Write a comment..."
              required
              className="form-textarea"
            />
          </div>
          <div className="modal-footer">
            <button type="submit" className="submit-button" disabled={!comment.trim()}>
              Add Comment
            </button>
          </div>
        </form>

        {isLoading ? (
          <div className="empty-state">Loading comments...</div>
        ) : (
          <div>
            {comments.comments?.map(comment => (
              <div key={comment.id} className="project-card">
                <div className="header">
                  <div>
                    <strong>{comment.commenter.email}</strong>
                    <div>
                      {new Date(comment.created_at).toLocaleDateString()}
                    </div>
                    <div>{comment.body}</div>
                  </div>
                  <div>
                    <button onClick={() => likeComment(comment.id)} className="create-button">
                      {comment.likes_count} likes
                    </button>
                    {comment.commenter.email == localStorage.getItem('authEmail') && (
                      <button onClick={() => deleteComment(comment.id)} className="cancel-button">
                        🗑️
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
            {comments.length === 0 && (
              <div className="empty-state">No comments yet. Be the first to comment!</div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

export default Comments
