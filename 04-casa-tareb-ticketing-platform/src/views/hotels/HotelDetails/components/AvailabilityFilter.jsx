import { SelectFormInput } from '@/components';
import Flatpicker from '@/components/Flatpicker';
import { useToggle } from '@/hooks';
import { useState } from 'react';
import { Button, Col, Container, Dropdown, DropdownDivider, DropdownMenu, DropdownToggle, Offcanvas, OffcanvasHeader } from 'react-bootstrap';
import { BsDashCircle, BsPencilSquare, BsPlusCircle, BsSearch } from 'react-icons/bs';

const AvailabilityFilter = () => {
  const {
    isOpen,
    toggle
  } = useToggle();
  const initialValue = {
    location: 'Événement musical',
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
      value += guests.adults + (guests.adults > 1 ? ' Adultes ' : ' Adulte ');
    }
    if (guests.children) {
      value += guests.children + (guests.children > 1 ? ' Enfants ' : ' Enfant');
    }
    if (guests.rooms) {
      value += guests.rooms + (guests.rooms > 1 ? ' Places ' : 'Place ');
    }
    return value;
  };
  const FilterInput = () => {
    return <div className="bg-light p-4 rounded w-100">
        <form className="row g-4">
          <Col md={6} lg={3}>
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
          <Col md={6} lg={3}>
            <div className="form-size-lg form-fs-md">
              <label className="form-label">Lieu d'évènement</label>
              <SelectFormInput className="form-select js-choice">
                <option value={-1}>Sélectionnez un lieu </option>
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
         
          <Col md={6} lg={2} className="mt-md-auto">
  <Button
    variant="primary"
    size="lg"
    className="w-100 mb-0 flex-centered"
    style={{
      backgroundColor: '#ffd700', // jaune
      borderColor: '#ffd700',
      color: '#000'
    }}
    href=""
  >
    <BsSearch className="fa-fw me-1" />
    Rechercher
  </Button>
</Col>

        </form>
      </div>;
  };
  return <div className="py-3 py-sm-0">
      <Container>
        <div className="d-none d-sm-block">
          <FilterInput />
        </div>
        <Button
  onClick={toggle}
  className="d-sm-none w-100 mb-0"
  type="button"
  style={{ backgroundColor: "#FFD700", borderColor: "#FFD700", color: "#000" }}
>
  <BsPencilSquare className="me-2" />
  Modifier la recherche
</Button>

        <Offcanvas show={isOpen} onHide={toggle} placement="top" className="offcanvas-sm" tabIndex={-1}>
          <OffcanvasHeader>
            <h5 className="offcanvas-title" id="offcanvasEditsearchLabel">
              Modifier la recherche
            </h5>
            <button type="button" onClick={toggle} className="btn-close" data-bs-dismiss="offcanvas" data-bs-target="#offcanvasEditsearch" aria-label="Close" />
          </OffcanvasHeader>
          <div className="offcanvas-body p-2">
            <FilterInput />
          </div>
        </Offcanvas>
      </Container>
    </div>;
};
export default AvailabilityFilter;