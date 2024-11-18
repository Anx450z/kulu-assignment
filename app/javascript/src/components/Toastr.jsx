import React from 'react'
import { toast, Slide } from 'react-toastify'
import '../styles/toastr.css'

const ToastrComponent = () => {
  return (
    <div className="container">
      <p className="message">{message}</p>
    </div>
  )
}

const showToastr = () => {
  toast.success(<ToastrComponent message={message} />, {
    position: toast.POSITION.BOTTOM_CENTER,
    transition: Slide,
    theme: 'colored',
  })
}

const isError = () => e && e.stack && e.message

const showErrorToastr = () => {
  const errorMessage = isError(error) ? error.message : error
  toast.error(<ToastrComponent message={errorMessage} />, {
    position: toast.POSITION.BOTTOM_CENTER,
    transition: Slide,
    theme: 'colored',
  })
}

const Toastr = {
  success: showToastr,
  error: showErrorToastr,
}

export default Toastr
