import { SelectFormInput, TextAreaFormInput } from '@/components';
import { yupResolver } from '@hookform/resolvers/yup';
import { Fragment } from 'react';
import { Button, Card, Col, Image, ProgressBar, Row, CardHeader, CardBody } from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import { BsArrowRight } from 'react-icons/bs';
import { FaStarHalfAlt } from 'react-icons/fa';
import { FaStar } from 'react-icons/fa6';
import * as yup from 'yup';
import avatar2 from '@/assets/images/avatar/02.jpg';
import avatar8 from '@/assets/images/avatar/08.jpg';
import avatar9 from '@/assets/images/avatar/09.jpg';
import hotel5 from '@/assets/images/category/hotel/4by3/man1.jpg';
import hotel7 from '@/assets/images/category/hotel/4by3/man2.jpg';
import hotel8 from '@/assets/images/category/hotel/4by3/man4.jpg';
const CustomerReview = () => {
  const reviewSchema = yup.object({
    review: yup.string().required('Please enter your review')
  });
  const {
    control,
    handleSubmit
  } = useForm({
    resolver: yupResolver(reviewSchema)
  });
  return <Card className="bg-transparent">
      <CardHeader className="border-bottom bg-transparent px-0 pt-0">
        <h3 className="card-title mb-0">Avis client</h3>
      </CardHeader>
      <CardBody className="pt-4 p-0">
        <Card className="bg-light p-4 mb-4">
          <Row className="g-4 align-items-center">
            <Col md={4}>
              <div className="text-center">
                <h2 className="mb-0">4.5</h2>
                <p className="mb-2">
                  Basé sur 120 avis</p>
                <ul className="list-inline mb-0">
                  {Array.from(new Array(4)).map((_val, idx) => <li className="list-inline-item me-1" key={idx}>
                      <FaStar size={18} className="text-warning" />
                    </li>)}
                  <li className="list-inline-item me-0">
                    <FaStarHalfAlt size={18} className="text-warning" />
                  </li>
                </ul>
              </div>
            </Col>
            <Col md={8}>
              <CardBody className="p-0">
                <Row className="gx-3 g-2 align-items-center">
                  {[85, 75, 60, 35, 15].map((progress, idx) => {
                  return <Fragment key={idx}>
                        <Col xs={9} sm={10}>
                          <ProgressBar variant="warning" now={progress} className="progress-sm bg-warning bg-opacity-15" />
                        </Col>
                        <Col xs={3} sm={2} className="text-end">
                          <span className="h6 fw-light mb-0">{progress}%</span>
                        </Col>
                      </Fragment>;
                })}
                </Row>
              </CardBody>
            </Col>
          </Row>
        </Card>
        <form onSubmit={handleSubmit(() => {})} className="mb-5">
          <div className="form-control-bg-light mb-3">
            <SelectFormInput className="form-select js-choice">
              <option>★★★★★ (5/5)</option>
              <option>★★★★☆ (4/5)</option>
              <option>★★★☆☆ (3/5)</option>
              <option>★★☆☆☆ (2/5)</option>
              <option>★☆☆☆☆ (1/5)</option>
            </SelectFormInput>
          </div>
          <TextAreaFormInput name="review" containerClass="form-control-bg-light mb-3" control={control} rows={3} />

          <Button
  type="submit"
  variant="primary"
  size="lg"
  className="mb-0 items-center"
  style={{ backgroundColor: '#FFD700', color: '#000', borderColor: '#FFD700' }}
>
  Post-évaluation <BsArrowRight className="ms-2" />
</Button>




        </form>
        <div className="d-md-flex my-4">
          <div className="avatar avatar-lg me-3 flex-shrink-0">
            <Image className="avatar-img rounded-circle" src={avatar9} alt="avatar" />
          </div>
          <div>
            <div className="d-flex justify-content-between mt-1 mt-md-0">
              <div>
                <h6 className="me-3 mb-0">Marieme Salah</h6>
                <ul className="nav nav-divider small mb-2">
                  <li className="nav-item">Date de l’événement : 13 novembre 2025</li>
                  <li className="nav-item">4 avis rédigés</li>
                </ul>
              </div>
              <div className="icon-md rounded text-bg-warning fs-6">4.5</div>
            </div>
            <p className="mb-2">
              Un événement musical incroyable avec Manal Amara qui a su enflammer la scène et captiver le public. L’ambiance était festive et chaque moment a été mémorable.{' '}
            </p>
            <Row className="g-4">
              <Col xs={4} sm={3} lg={2}>
                <Image src={hotel7} className="rounded" />
              </Col>
              <Col xs={4} sm={3} lg={2}>
                <Image src={hotel8} className="rounded" />
              </Col>
              <Col xs={4} sm={3} lg={2}>
                <Image src={hotel5} className="rounded" />
              </Col>
            </Row>
          </div>
        </div>
        <div className="my-4 ps-2 ps-md-3">
          <div className="d-md-flex p-3 bg-light rounded-3">
            <img className="avatar avatar-sm rounded-circle me-3" src={avatar2} alt="avatar" />
            <div className="mt-2 mt-md-0">
              <h6 className="mb-1">Directeur</h6>
              <p className="mb-0">Merci pour votre retour. Nous apprécions vos observations et veillerons à maintenir la qualité et la discrétion dans tous nos services afin de toujours satisfaire vos attentes. </p>
            </div>
          </div>
        </div>
        <hr />
        <div className="d-md-flex my-4">
          <div className="avatar avatar-lg me-3 flex-shrink-0">
            <Image className="avatar-img rounded-circle" src={avatar8} alt="avatar" />
          </div>
          <div>
            <div className="d-flex justify-content-between mt-1 mt-md-0">
              <div>
                <h6 className="me-3 mb-0">Salah Mohamed</h6>
                <ul className="nav nav-divider small mb-2">
                  <li className="nav-item">Date de l’événement : 14 Septembre 2025</li>
                  <li className="nav-item">2 avis rédigés</li>
                </ul>
              </div>
              <div className="icon-md rounded text-bg-warning fs-6">4.0</div>
            </div>
            <p className="mb-0">
              La musique était entraînante et a tenu tout le monde captivé tout au long de la soirée. Excellente ambiance et événement très bien organisé !
            </p>
          </div>
        </div>
        <hr />
        <div className="text-center">
          <Button
  variant="primary-soft"
  className="mb-0"
  style={{ backgroundColor: '#fff9c4', color: '#000' }}
>
  Charger plus
</Button>

        </div>
      </CardBody>
    </Card>;
};
export default CustomerReview;