import { useClipboard } from '@/hooks';
import { Button, CardFooter, Col, Container, Row } from 'react-bootstrap';
import { FaPrint, FaTrash } from 'react-icons/fa6';
import { Link,  useNavigate } from 'react-router-dom';
import { useNotificationContext,useAuthContext, usePanier } from '@/states';
import React, { useState } from 'react';
import DeleteConfirmationModal from './DeleteConfirmationModal';


const MyOfferList = (eventBean) => {
  const { user, removeSession } = useAuthContext(); // <-- récupère user
  const navigate = useNavigate();
  const { items, removeItem, updateItem, clearPanier, getTotal, getItemCount } = usePanier();// gestion de panier

  const [showModal, setShowModal] = useState(false);
  const [itemToDelete, setItemToDelete] = useState(null);

  const handleDeleteClick = (item) => {
    setItemToDelete(item);
    setShowModal(true);
  };

  const handleClose = () => {
    setShowModal(false);
    setItemToDelete(null);
  };

  const handleConfirmDelete = () => {
    if (itemToDelete) {
      removeItem(itemToDelete.id);
    }
    handleClose();
  };


  const [, copy] = useClipboard();
  const {
    showNotification
  } = useNotificationContext();
  const onCopy = text => {
    copy(text).then(copied => {
      if (copied) {
        showNotification({
          message: 'Copied To Clipboard',
          type: 'success',
          delay: 1500
        });
      }
    });
  };
  return <section>
      <Container>
        <Row className="g-4">
          <Col xs={12}>
            <div className="table-responsive">
              <table className="table table-bordered ">
                <thead className="table-secondary">
                  <tr>
                    <th scope="col">Event</th>
                    <th scope="col">Participant</th>
                    <th scope="col">Table</th>
                    <th scope="col">Chaise</th>
                     <th scope="col">Prix</th>
                    <th scope="col">Action</th>
                   
                  </tr>
                </thead>
                <tbody className="align-middle">
                 
                  {items.map((item) => (
          <tr >
                    <td width="30%"  className="h6 mb-0">{item.event.title}</td>
                    <td width="25%"  className="h6 mb-0">{item.name}</td>
                    <td width="10%" className="h6 fw-normal mb-0">{item.tableNumber}</td>
                    <td width="10%" className="h6 fw-normal mb-0">{item.chairNumber}</td>
                     <td width="15%" className="h6 fw-normal mb-0 text-center text-md-end">{item.price.toFixed(3)} TND</td>
                    <td width="10%" className="h6 fw-normal mb-0 text-center">
              {/* Delete button with an icon and an onClick handler */}
              
              <Button
                variant="danger"
                onClick={() => handleDeleteClick(item)}
              >
                <FaPrint />
              </Button>
            </td>
                   
                  </tr>
          ))}
<DeleteConfirmationModal
        show={showModal}
        handleClose={handleClose}
        handleConfirm={handleConfirmDelete}
        itemName={itemToDelete?.name}
      />
                 
                  


                </tbody>
                <tfoot>
    <tr>
      <td colspan="4" class="h6 fw-normal mb-0 text-end">Total:</td>
      <td colspan="1" className="h6 fw-normal mb-0 text-center text-md-end text-info">{getTotal().toFixed(3)} TND</td>
      <td colspan="1" class="text-end"></td>
    </tr>
  </tfoot>
              </table>
            </div>
          </Col>
         
        </Row>
        
      </Container>
      
    </section>;
};
export default MyOfferList;