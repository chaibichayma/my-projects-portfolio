import { TinySlider } from '@/components';
import { useToggle } from '@/hooks';
import { currency, useLayoutContext } from '@/states';
import { splitArray } from '@/utils';
import { Button, Card, CardBody, CardHeader, Col, Image, Modal, ModalBody, ModalHeader, Row } from 'react-bootstrap';
import { renderToString } from 'react-dom/server';
import { BsArrowLeft, BsArrowRight, BsEyeFill } from 'react-icons/bs';
import { FaCheckCircle, FaTrash } from 'react-icons/fa';
import { Link, useNavigate } from 'react-router-dom';
import 'tiny-slider/dist/tiny-slider.css';
import { BsTrash } from 'react-icons/bs';
import "./Appp.css";

const amenities = ['Salle climatisée', 'Wi-Fi', 'Tables et chaises', 'Scène', 'Décoration', 'Parking', 'Service de sécurité', 'Restauration'];
const RoomCard = ({
  features,
  images,
  name,
  price,
  sale,
  schemes
}) => {
  const {
    isOpen,
    toggle
  } = useToggle();
  const {
    dir
  } = useLayoutContext();
  const roomSliderSettings = {
    nested: 'inner',
    autoplay: false,
    controls: true,
    autoplayButton: false,
    autoplayButtonOutput: false,
    controlsText: [renderToString(<BsArrowLeft size={16} />), renderToString(<BsArrowRight size={16} />)],
    arrowKeys: true,
    items: 1,
    nav: false,
    autoplayDirection: dir === 'ltr' ? 'forward' : 'backward'
  };
  const navigate = useNavigate();

  const handleValider = () => {
    navigate('/hotels/payment'); // ← chemin défini dans ton router
  };

  
  const chunk_size = 2;
  const amenitiesChunks = splitArray(amenities, chunk_size);
  return <Card className="shadow p-3">
      <Row className="g-4">
        <Col md={5} className="position-relative">
          {sale && <div className="position-absolute top-0 start-0 z-index-1 mt-3 ms-4">
              <div className="badge text-bg-danger">{sale}</div>
            </div>}
          <div className="tiny-slider arrow-round arrow-xs arrow-dark overflow-hidden rounded-2">
            <TinySlider settings={roomSliderSettings}>
              {images.map((image, idx) => {
              return <div key={idx}>
                    <Image src={image} alt="Card image" />
                  </div>;
            })}
            </TinySlider>
          </div>
          <Link to="" className="btn btn-link text-decoration-underline p-0 mb-0 mt-1 items-center" onClick={toggle}>
            <BsEyeFill className=" me-1" />
            Voir plus de détails
          </Link>
        </Col>
        <Col md={7}>
          <div className="card-body d-flex flex-column h-100 p-0">
            <h5 className="card-title">
              <Link to="">{name}</Link>
            </h5>
            <ul className="nav nav-divider mb-2">
              {features.map((feature, idx) => <li key={idx} className="nav-item">
                  {feature}
                </li>)}
            </ul>

            {schemes ? schemes.map((scheme, idx) => <p key={idx} className="text-success mb-0">
                  {scheme}
                </p>) : <p className="text-danger mb-3">Non remboursable</p>}

            <div className="d-sm-flex justify-content-sm-between align-items-center mt-auto">
              <div className="d-flex align-items-center">
  <h5 className="fw-bold mb-0 me-7">
    {currency}{price}
  </h5>

  <FaTrash
    style={{
      cursor: "pointer",
      color: "#000",        // noir moderne
      fontSize: "16px",     // taille élégante
      opacity: 0.75,        // effet moderne
    }}
    className="ms-1"
    onClick={() => console.log("Supprimer la carte")}
  />
</div>

              <div className="mt-3 mt-sm-0">
                <Button
  size="sm"
  className="mb-0"
  style={{ backgroundColor: "#FFD700", borderColor: "#FFD700", color: "#000" }}
  onClick={handleValider}
>
  Acheter
</Button>




              </div>
            </div>
          </div>

          <Modal show={isOpen} onHide={toggle} className="fade">
            <ModalHeader className="p-3">
              <h5 className="modal-title mb-0" id="roomDetailLabel">
                Détails d’événement
              </h5>
              <button type="button" onClick={toggle} className="btn-close" />
            </ModalHeader>
            <ModalBody className="p-0">
              <Card className="bg-transparent p-3">
                <div className="tiny-slider arrow-round arrow-dark overflow-hidden rounded-2">
                  <TinySlider settings={roomSliderSettings} className="rounded-2 overflow-hidden">
                    {images.map((image, idx) => <div key={idx}>
                        <Image src={image} className="rounded-2" alt="Card image" />
                      </div>)}
                  </TinySlider>
                </div>
                
                <CardBody>
                  <p>
                    La salle est entièrement équipée et confortable, avec climatisation, projecteur avec écran et système de sonorisation. Elle dispose de tables et chaises adaptées, ainsi que d’un espace scène . Un accès Wi-Fi gratuit, un parking et un accès pour personnes à mobilité réduite sont disponibles. Des services supplémentaires tels que la restauration, la décoration et l’accueil peuvent être fournis. Des options complémentaires incluent un photographe, un service de sécurité et tout le matériel audiovisuel nécessaire pour le bon déroulement de l’événement.
                  </p>
                  <h5 className="mb-0">Équipements</h5>
                  {amenitiesChunks.map((chunk, idx) => {
                  return <Row key={idx}>
                        {chunk.map((item, idx) => {
                      return <Col key={idx} md={6}>
                              <ul className="list-group list-group-borderless mt-2 mb-0">
                                <li className="list-group-item d-flex mb-0">
                                  <FaCheckCircle className="text-success me-2" />
                                  <span className="h6 fw-light mb-0">{item}</span>
                                </li>
                              </ul>
                            </Col>;
                    })}
                      </Row>;
                })}
                </CardBody>
              </Card>
            </ModalBody>
          </Modal>
        </Col>
      </Row>
    </Card>;
};
export default RoomCard;