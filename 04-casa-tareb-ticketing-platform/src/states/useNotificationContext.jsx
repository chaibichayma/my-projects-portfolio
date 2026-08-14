import { createContext, useContext, useState } from 'react';
import { ToastBody, ToastHeader } from 'react-bootstrap';
import Toast from 'react-bootstrap/Toast';
import ToastContainer from 'react-bootstrap/ToastContainer';
const NotificationContext = createContext(undefined);
function Toastr({
  show,
  title,
  message,
  onClose,
  variant = 'light',
  delay
}) {
  return <ToastContainer className="m-3 position-fixed" position="top-end">
      <Toast bg={variant.toLowerCase()} delay={delay} show={show} onClose={onClose} autohide>
        {title && <ToastHeader className={`text-${variant}`}>
            <strong className="me-auto">{title}</strong>
          </ToastHeader>}
        <ToastBody className={['dark', 'danger', 'success'].includes(variant) ? 'text-white' : ''}>{message}</ToastBody>
      </Toast>
    </ToastContainer>;
}
export function useNotificationContext() {
  const context = useContext(NotificationContext);
  if (context === undefined) {
    throw new Error('useNotificationContext must be used within an NotificationProvider');
  }
  return context;
}
const notificationTypes = {
  error: 'danger',
  info: 'info',
  success: 'success',
  default: 'light'
};
export function NotificationProvider({
  children
}) {
  const defaultConfig = {
    show: false,
    message: '',
    title: '',
    delay: 2000
  };
  const [config, setConfig] = useState(defaultConfig);
  const hideNotification = () => {
    setConfig({
      show: false,
      message: '',
      title: ''
    });
  };
  const showNotification = ({
    title,
    message,
    type,
    delay = 2000
  }) => {
    setConfig({
      show: true,
      title,
      message,
      variant: notificationTypes[type] ?? 'light',
      onClose: hideNotification,
      delay
    });
    setTimeout(() => {
      setConfig(defaultConfig);
    }, delay);
  };
  return <NotificationContext.Provider value={{
    showNotification
  }}>
      <Toastr {...config} />
      {children}
    </NotificationContext.Provider>;
}