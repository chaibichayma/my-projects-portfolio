
import { Card, CardBody, CardHeader, Col, Container, Row} from 'react-bootstrap';
import {  BsShieldFillCheck } from 'react-icons/bs';
import { FaCheckCircle } from 'react-icons/fa';
import CinemaLayout from './CinemaLayout';
import Legend from './Legend';
import { useLocation } from 'react-router-dom';
import CinemaPlan from './CinemaPlan';


const AboutHotel = () => {
 
  
  const location = useLocation();
  const { eventBean } = location.state || {};

 
 

  return <section className="pt-0">
        
      <Container data-sticky-container>
        <Row className="g-4 g-xl-5">
          <Col xl={7} className="order-1">
            <div className="vstack gap-5">
              <Card className="bg-transparent">

                <CardHeader className="bg-transparent px-0 pt-0">
                  <h3 className="mb-0">{eventBean.title}</h3>
                </CardHeader>
               
              </Card>
              
             
            

            </div>
          </Col>
          
        </Row>
      </Container>
           {/* Wrapper pour CinemaLayout + image */}
  <div className="d-flex flex-column flex-lg-row justify-content-lg-end align-items-lg-center mt-4 px-3 px-lg-5">
    <div className="flex-grow-1">
     <CinemaPlan event={eventBean}/>
    </div>
    
  </div>


    </section>;
};
export default AboutHotel;