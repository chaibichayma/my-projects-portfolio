import { Card, CardBody, Col, Container, Dropdown, DropdownItem, DropdownMenu, DropdownToggle, Image, Row } from 'react-bootstrap';
import { BsCalendar, BsCurrencyDollar, BsFilePdf, BsPeople, BsPerson, BsShare, BsVr, BsWallet2 } from 'react-icons/bs';
import { FaCopy, FaLinkedin } from 'react-icons/fa6';
import { FaFacebookSquare, FaTwitterSquare } from 'react-icons/fa';
import gallery4 from '@/assets/images/gallery/rr.png';
import { currency } from '@/states';
const ConfirmTicket = () => {
  return <section className="pt-4">
      <Container>
        <Row>
          <Col md={10} xl={8} className="mx-auto">
            <Card className="shadow">
              <Image src={gallery4} className="rounded-top" />
              <CardBody className="text-center p-4">
                <h1 className="card-title fs-3">🎊 Félicitations! 🎊</h1>
                <p className="lead mb-3">Votre réservation a été faite pour un événement.</p>
               <h5 className="mb-4" style={{ color: "#000" }}>
  Nom de l'évènement
</h5>

                <Row className="justify-content-between text-start mb-4">
                  <Col lg={5}>
                    <ul className="list-group list-group-borderless">
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="mb-0 items-center">
                          <BsVr className=" fa-fw me-2" />
                          Numéro de commande:
                        </span>
                        <span className="h6 fw-normal mb-0">BS-58678</span>
                      </li>
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="mb-0 items-center">
                          <BsPerson className=" fa-fw me-2" />
                          Réservé par:
                        </span>
                        <span className="h6 fw-normal mb-0">Chaibi Chayma</span>
                      </li>
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="mb-0 items-center">
                          <BsWallet2 className=" fa-fw me-2" />
                          
                           Mode de paiement:
                        </span>
                        <span className="h6 fw-normal mb-0">Credit card</span>
                      </li>
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="d-flex align-items-center mb-0">
  <span
    style={{
      width: 26,
      height: 26,
      borderRadius: "50%",
    
      color: "#888888", 
      fontWeight: "bold",
      fontSize: "15px",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      marginRight: "8px",
    }}
  >
    DT
  </span>
  Prix total :
</span>


                        <span className="h6 fw-normal mb-0">1200 TND</span>
                      </li>
                    </ul>
                  </Col>
                  <Col lg={5}>
                    <ul className="list-group list-group-borderless">
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="mb-0 items-center">
                          <BsCalendar className=" fa-fw me-2" />
                          Date:
                        </span>
                        <span className="h6 fw-normal mb-0">29 July 2026</span>
                      </li>
                      
                      <li className="list-group-item d-sm-flex justify-content-between align-items-center">
                        <span className="mb-0 items-center">
                          <BsPeople className=" fa-fw me-2" />
                          Numéro de tables:
                        </span>
                        <span className="h6 fw-normal mb-0">3</span>
                      </li>
                      <li className="list-group-item d-sm-flex justify-content-between align-items-centerr">
                        <span className="mb-0 items-centerr">
                          <BsPeople className=" fa-fw me-2" />
                          Nombre de chaises:
                        </span>
                        <span className="h6 fw-normal mb-0">3</span>
                      </li>
                    </ul>
                  </Col>
                </Row>
                <div className="d-sm-flex justify-content-sm-end d-grid">
                  <Dropdown className="me-sm-2 mb-2 mb-sm-0">
                    <DropdownToggle as="button" type="button" className="arrow-none btn btn-light mb-0 w-100 items-center" role="button">
                      <BsShare className=" me-2" />
                      Share
                    </DropdownToggle>
                    <DropdownMenu align="end" className="min-w-auto shadow rounded">
                   
                        <DropdownItem className="items-center">
                          <FaTwitterSquare className="me-2" />
                          Twitter
                        </DropdownItem>
                   
                        <DropdownItem className="items-center">
                          <FaFacebookSquare className="me-2" />
                          Facebook
                        </DropdownItem>
                 
                        <DropdownItem className="items-center">
                          <FaLinkedin className="me-2" />
                          LinkedIn
                        </DropdownItem>
                  
                        <DropdownItem className="items-center">
                          <FaCopy className="me-2" />
                          Copy link
                        </DropdownItem>
                     
                    </DropdownMenu>
                  </Dropdown>
                  <button
  className="btn mb-0 d-flex align-items-center"
  style={{ backgroundColor: "#FFD700", color: "#000", border: "none" }}
>
  <BsFilePdf className="me-2" />
  Download PDF
</button>

                </div>
              </CardBody>
            </Card>
          </Col>
        </Row>
      </Container>
    </section>;
};
export default ConfirmTicket;