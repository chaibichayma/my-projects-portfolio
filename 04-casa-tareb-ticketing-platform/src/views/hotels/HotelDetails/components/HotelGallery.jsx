
import { useToggle } from '@/hooks';
import { Button, Card, Col, Container, Dropdown, DropdownItem, DropdownMenu, DropdownToggle, Row } from 'react-bootstrap';
import {  BsEyeFill, BsFullscreen, BsGeoAlt } from 'react-icons/bs';
import { FaFacebookSquare, FaShareAlt, FaTwitterSquare } from 'react-icons/fa';
import { FaCopy, FaHeart, FaLinkedin } from 'react-icons/fa6';
import { Link } from 'react-router-dom';

import { useLocation } from 'react-router-dom';

const HotelGallery = () => {
  const {
    isOpen,
    toggle
  } = useToggle();
 const location = useLocation();
  const { eventBean } = location.state || {};
  return <>
      <section className="py-0 pt-sm-5">
        <Container className="position-relative">
          <Row className="mb-3">
            <Col xs={12}>
              <div className="d-lg-flex justify-content-lg-between mb-1">
                <div className="mb-2 mb-lg-0">
                  <h1 className="fs-2">Casa Tarab – Lieu d’événements musicaux</h1>
                  <p className="fw-bold mb-0 items-center flex-wrap">
                    <BsGeoAlt className=" me-2" />
                    W887+7G4, Gammarth
                    <Link to="" onClick={toggle} className="ms-3 text-decoration-underline items-center" data-bs-toggle="modal" data-bs-target="#mapmodal">
                      <BsEyeFill className="me-1" />
                      Afficher sur la carte
                    </Link>
                  </p>
                </div>
               
              </div>
            </Col>
          </Row>
          
        </Container>
      </section>

      <section className="card-grid pt-0">
        <Container>
          <Row className="g-2">
            <Col md={12}>
              
                <Card className="card-grid-lg card-element-hover card-overlay-hover overflow-hidden" style={{
                backgroundImage: `url(${eventBean.urlImage})`,
                backgroundPosition: 'center left',
                backgroundSize: 'cover'
              }}>
                  <div className="hover-element position-absolute w-100 h-100">
                    <BsFullscreen size={28} className=" fs-6 text-white position-absolute top-50 start-50 translate-middle bg-dark rounded-1 p-2 lh-1" />
                  </div>
                </Card>
              
            </Col>
            
          </Row>
        </Container>
      </section>

     
    </>;
};
export default HotelGallery;