import { useClipboard } from '@/hooks';
import { Button, CardFooter, Col, Container, Row,Image, Table } from 'react-bootstrap';
import { FaTrash } from 'react-icons/fa6';
import { Link,  useNavigate } from 'react-router-dom';
import { useNotificationContext,useAuthContext, usePanier } from '@/states';
import React, { useState } from 'react';
import DeleteConfirmationModal from './DeleteConfirmationModal';
import Form from 'react-bootstrap/Form';


const OfferDetails = (eventBean) => {
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

  const updateCellItemNameChange = (e, id) => {
    updateItem(id,{'name':e.target.value});
  };
   const updateCellItemMailChange = (e, id) => {
    updateItem(id,{'mail':e.target.value});
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
                    <th scope="col">Mail</th>
                    <th scope="col">Table</th>
                    <th scope="col">Chaise</th>
                     <th scope="col">Prix</th>
                    <th scope="col">Action</th>
                   
                  </tr>
                </thead>
                <tbody className="align-middle">
                 
                  {items.map((item) => (
          <tr >
                    <td width="10%"  className="h6 mb-0">
                      
                      <Image
                  src={item.event.urlImage}
                  alt={item.event.title}
                  fluid // Makes image responsive (max-width: 100%, height: auto)
                  style={{ width: '100px', height: 'auto' }} // Set a specific size for the table cell
                  rounded // Optional: adds rounded corners
                />
                      
                      </td>
                    <td width="25%"  className="h6 mb-0">
                     <Form.Control
                type="text"
                defaultValue={item.name}
                className="text-primary bg-light border-success"
                onChange={(e) => updateCellItemNameChange(e, item.id)}
                // Optional: add sizing, e.g., size="sm"
                size="sm"
              />

                      

                    </td>
                    <td width="25%"  className="h6 mb-0" ><Form.Control
                type="text"
                defaultValue={item.mail}
                
                className="text-primary bg-light border-success"
                onChange={(e) => updateCellItemMailChange(e, item.id)}
                // Optional: add sizing, e.g., size="sm"
                size="sm"
              /></td>
                    <td width="10%" className="h6 fw-normal mb-0">{item.tableNumber}</td>
                    <td width="10%" className="h6 fw-normal mb-0">{item.chairNumber}</td>
                     <td width="10%" className="h6 fw-normal mb-0 text-center text-md-end">{item.price.toFixed(3)} TND</td>
                    <td width="10%" className="h6 fw-normal mb-0 text-center">
              {/* Delete button with an icon and an onClick handler */}
              
              <Button
                variant="danger"
                onClick={() => handleDeleteClick(item)}
              >
                <FaTrash />
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
      <td colSpan="5" className="h6 fw-normal mb-0 text-end">Total:</td>
      <td colSpan="1" className="h6 fw-normal mb-0 text-center text-md-end text-info">{getTotal().toFixed(3)} TND</td>
      <td colSpan="1" className="text-end"></td>
    </tr>
  </tfoot>
              </table>
            </div>
          </Col>
         
        </Row>
        <CardFooter className="bg-transparent text-center border-top">
        <button
  className="btn w-100 mb-0 btn-info "
  onClick={() => {
    if (user) {
      navigate('/evenement/payment');
    } else {
      navigate('/auth/sign-in');
    }
  }}
>
  Paiement
</button>

      </CardFooter>
      </Container>
      
    </section>;
};
export default OfferDetails;