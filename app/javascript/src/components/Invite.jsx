import React, { useState } from 'react'
import axios from 'axios'
import useSWR from 'swr'
import '../styles/invite.css'
import '../styles/project.css'

export const Invite = (props) => {
  const handleAccept = async inviteId => {
    try {
      await axios.post(`/api/v1/invites/${inviteId}/accept`)
      props.mutate()
    } catch (error) {
      console.error('Error accepting invite:', error)
    }
  }

  const handleDecline = async inviteId => {
    try {
      await axios.delete(`/api/v1/invites/${inviteId}`)
      props.mutate()
    } catch (error) {
      console.error('Error declining invite:', error)
    }
  }

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
            {props.invites?.map(invite => (
              <div key={invite.id} className="invite-item">
                <div className="invite-info">
                  <h3>{invite.project.title}</h3>
                  <p>{invite.project.description}</p>
                  <p>Owner: {invite.project.owner.email}</p>
                </div>
                <div className="invite-actions">
                  <button className="create-button" onClick={() => handleAccept(invite.id)}>
                    Accept
                  </button>
                  <button className="cancel-button" onClick={() => handleDecline(invite.id)}>
                    Decline
                  </button>
                </div>
              </div>
            ))}
            {props.invites?.length === 0 && <p className="no-invites">No pending invites</p>}
          </div>
        </div>
      </div>
    </>
  )
}
