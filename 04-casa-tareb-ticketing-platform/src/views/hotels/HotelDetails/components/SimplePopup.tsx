// SimplePopup.tsx
import { FC } from 'react';
import { Modal, Button } from 'react-bootstrap';

interface SimplePopupProps {
  show: boolean;
  handleClose: () => void;
}

const SimplePopup: FC<SimplePopupProps> = ({ show, handleClose }) => {
  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Popup</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>Bonjour</p>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>
          Fermer
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default SimplePopup;
