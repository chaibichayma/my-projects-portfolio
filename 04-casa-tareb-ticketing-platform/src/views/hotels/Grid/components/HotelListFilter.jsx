import { SelectFormInput, TextFormInput } from '@/components';
import { useToggle } from '@/hooks';
import { yupResolver } from '@hookform/resolvers/yup';
import Nouislider from 'nouislider-react';
import { useState } from 'react';
import { Button, Card, Col, Collapse, Container, FormCheck, Row, CardBody, CardHeader } from 'react-bootstrap';
import FormCheckInput from 'react-bootstrap/esm/FormCheckInput';
import FormCheckLabel from 'react-bootstrap/esm/FormCheckLabel';
import { useForm } from 'react-hook-form';
import { BsGridFill, BsListUl, BsSliders, BsStarFill } from 'react-icons/bs';
import { Link } from 'react-router-dom';
import * as yup from 'yup';
import "./App.css";
const amenities = [
  'Sonorisation professionnelle',
  'Éclairage de scène',
  'Espace lounge',
  'Bar sur place',
  'Restauration',
  'Vestiaire',
  'Sécurité',
  'Accès PMR',
  'Billetterie sur place',
  'Parking',
  'Zone fumeurs'
];

const HotelListFilter = () => {
  const {
    isOpen,
    toggle
  } = useToggle();
  const [priceRange, setPriceRange] = useState(['700', '1500']);
  const filterSchema = yup.object({
    hotelName: yup.string().required('Please enter hotel name')
  });
  const {
    control,
    handleSubmit
  } = useForm({
    resolver: yupResolver(filterSchema)
  });
  return <section className="pt-0 pb-4">
      <Container className="position-relative">
        <Row>
          <Col xs={12}>
            <div className="d-flex justify-content-between">
  <CardHeader className="bg-transparent px-0 pt-0">
                  <h3 className="mb-0">Evénements casa tarab</h3>
                </CardHeader>
  
              
            </div>
          </Col>
        </Row>
       
      </Container>
    </section>;
};
export default HotelListFilter;