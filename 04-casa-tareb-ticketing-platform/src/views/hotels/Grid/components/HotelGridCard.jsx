import { TinySlider } from '@/components';
import { useToggle } from '@/hooks';
import { currency, useLayoutContext } from '@/states';
import { Card, CardBody, CardFooter } from 'react-bootstrap';
import { renderToString } from 'react-dom/server';
import { BsArrowLeft, BsArrowRight, BsBookmark, BsBookmarkFill, BsStarFill } from 'react-icons/bs';
import { Link } from 'react-router-dom';
import 'tiny-slider/dist/tiny-slider.css';
const HotelGridCard = ({
  rowBean
}) => {
  const {
    isOpen,
    toggle
  } = useToggle();
  const {
    dir
  } = useLayoutContext();
  const gridSliderSettings = {
    nested: 'inner',
    autoplay: false,
    controls: true,
    autoplayButton: false,
    autoplayButtonOutput: false,
    controlsText: [renderToString(<BsArrowLeft size={16} />), renderToString(<BsArrowRight size={16} />)],
    arrowKeys: true,
    items: 1,
    autoplayDirection: dir === 'ltr' ? 'forward' : 'backward',
    nav: false
  };
  return <Card className="shadow p-2 pb-0 h-100">
      {rowBean.isSoldOut && <div className="position-absolute top-0 start-0 z-index-1 m-4">
          <div className="badge bg-danger text-white">Sold Out</div>
        </div>}
      <div className="tiny-slider arrow-round arrow-xs arrow-dark rounded-2 overflow-hidden ">
        <TinySlider settings={gridSliderSettings}>
           <div>
              <img src={rowBean.urlImage} alt="Card image" />
            </div>)
        </TinySlider>
      </div>
      <CardBody className="px-3 pb-0">
        <div className="d-flex justify-content-between mb-3 align-items-center">
          <ul to="" className="badge bg-youtube text-white items-center">
           
            
            {rowBean.isSoldOut && <li> Sold Out</li>}
          </ul>
          
        </div>
        <h5 className="card-title">
          <ul >{rowBean.title}</ul>
        </h5>
        <ul className="nav nav-divider mb-2 mb-sm-3">
          { <li className="nav-item">
              {rowBean.eventDate}
            </li>}
        </ul>
      </CardBody>
      <CardFooter className="pt-0">
        <div className="d-sm-flex justify-content-sm-between align-items-center">
          <div className="d-flex align-items-center">
            <h5 className="fw-normal text-success mb-0 me-1">
              {rowBean.priceTicket} TND
            </h5>
          
          </div>
          <div className="mt-2 mt-sm-0">
            <Link to="/evenement/detail" state={{ eventBean: rowBean }}  className="btn btn-sm btn-primary-soft mb-0 w-100 items-center" style={{
    backgroundColor: '#ffd700', // jaune
    color: '#000',               // texte noir,
    fontSize:20
  }}>
              Réserver
              <BsArrowRight className=" ms-2" />
            </Link>
          </div>
        </div>
      </CardFooter>
    </Card>;
};
export default HotelGridCard;