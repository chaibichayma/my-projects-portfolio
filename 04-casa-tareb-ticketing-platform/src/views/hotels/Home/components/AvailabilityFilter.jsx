import Flatpicker from '@/components/Flatpicker';
import { SelectFormInput } from '@/components/form';
import { useState } from 'react';
import { Button, Card, Col, Dropdown, DropdownDivider, DropdownMenu, DropdownToggle, FormLabel, Row } from 'react-bootstrap';
import { BsCalendar, BsDashCircle, BsGeoAlt, BsPerson, BsPlusCircle, BsSearch } from 'react-icons/bs';
const AvailabilityFilter = () => {
  const initialValue = {
    location: 'San Jacinto, USA',
    stayFor: [new Date(), new Date(Date.now() + 5 * 24 * 60 * 60 * 1000)],
    guests: {
      adults: 2,
      rooms: 1,
      children: 0
    }
  };
  const [formValue, setFormValue] = useState(initialValue);
  const updateGuests = (type, increase = true) => {
    const val = formValue.guests[type];
    setFormValue({
      ...formValue,
      guests: {
        ...formValue.guests,
        [type]: increase ? val + 1 : val > 1 ? val - 1 : 0
      }
    });
  };
  const getGuestsValue = () => {
    let value = '';
    const guests = formValue.guests;
    if (guests.adults) {
      value += guests.adults + (guests.adults > 1 ? ' Adults ' : ' Adult ');
    }
    if (guests.children) {
      value += guests.children + (guests.children > 1 ? ' Children ' : ' Child ');
    }
    if (guests.rooms) {
      value += guests.rooms + (guests.rooms > 1 ? ' Rooms ' : ' Room ');
    }
    return value;
  };
  return <Row>
      <Col xl={10} className="position-relative mt-n3 mt-xl-n9">
        <h6 className="d-none d-xl-block mb-3">Check Availability</h6>

        <Card as="form" className="shadow rounded-3 position-relative p-4 pe-md-5 pb-5 pb-md-4">
          <Row className="g-4 align-items-center">
        <Col md={6} lg={4}>
            <div className="form-size-lg form-fs-md">
              <label className="form-label">Artiste</label>
              <SelectFormInput className="form-select js-choice">
                <option value={-1}>Sélectionnez un artiste</option>
                <option>Amina Fakhet</option>
                <option>Saber Rebaï</option>
                <option>Emel Mathlouthi</option>
              </SelectFormInput>
            </div>
          </Col>
           <Col md={6} lg={4}>
            <div className="form-size-lg form-fs-md">
              <label className="form-label">Lieu d'évènement</label>
              <SelectFormInput className="form-select js-choice">
                <option value={-1}>Sélectionnez un lieu d'évènement</option>
                <option>Sousse</option>
                <option>Tunis</option>
                <option>Mahdia</option>
              </SelectFormInput>
            </div>
          </Col>

          <Col md={6} lg={4}>
            <div className="form-fs-md">
              <label className="form-label">Horaires de l’événement</label>
              <Flatpicker value={formValue.stayFor} getValue={val => setFormValue({
              ...formValue,
              stayFor: val
            })} options={{
              mode: 'range',
              dateFormat: 'd M'
            }} className="form-control-lg" />
            </div>
          </Col>
          
      </Row>


          <div className="btn-position-md-middle">
            <button type="submit" className="icon-lg btn btn-round btn-primary mb-0 flex-centered">
              <BsSearch className=" fa-fw" />
            </button>
          </div>
        </Card>
      </Col>
    </Row>;
};
export default AvailabilityFilter;