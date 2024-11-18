import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import '../styles/invite.css'
import '../styles/project.css'

export const Invite = props => {
  const getInvites = async () => {
    const response = await axios.get(`/api/v1/invites`)
    props.setInviteCount(response.data.invites.length || 0)
    return response.data
  }

  const handleAccept = async inviteId => {
    try {
      await axios.post(`/api/v1/invites/${inviteId}/accept`)
      mutate()
    } catch (error) {
      console.error('Error accepting invite:', error)
    }
  }

  const handleDecline = async inviteId => {
    try {
      await axios.delete(`/api/v1/invites/${inviteId}`)
      mutate()
    } catch (error) {
      console.error('Error declining invite:', error)
    }
  }

  const { data: invites = [], mutate } = useSWR('/api/v1/invites', getInvites)

  return (
    <>
      <div
        className="modal-backdrop"
        onClick={e => {
          if (e.target === e.currentTarget) setIsModalOpen(false)
        }}>
        <div className="modal">
          <div className="modal-header">
            <h2>Project Invites</h2>
            <button className="close-button" onClick={() => props.setIsModalOpen(false)}>
              ×
            </button>
          </div>
          <div className="invites-list">
            {invites.invites?.map(invite => (
              <div key={invite.id} className="invite-item">
                <div className="invite-info">
                  <h3>{invite.project.title}</h3>
                  <p>{invite.project.description}</p>
                  <p>Owner: {invite.project.owner.email}</p>
                </div>
                <div className="invite-actions">
                  <button className="accept-button" onClick={() => handleAccept(invite.id)}>
                    Accept
                  </button>
                  <button className="decline-button" onClick={() => handleDecline(invite.id)}>
                    Decline
                  </button>
                </div>
              </div>
            ))}
            {invites?.length === 0 && <p className="no-invites">No pending invites</p>}
          </div>
        </div>
      </div>
    </>
  )
}