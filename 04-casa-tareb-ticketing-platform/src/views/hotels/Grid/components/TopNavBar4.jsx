import { AppMenu, LogoBox } from '@/components';
import { useScrollEvent, useToggle } from '@/hooks';
import { useAuthContext, useLayoutContext,usePanier } from '@/states';
import clsx from 'clsx';
import { Card, CardBody, CardFooter, CardHeader, Container, Dropdown, DropdownDivider, DropdownItem, DropdownMenu, DropdownToggle, ListGroup, ListGroupItem, Navbar, OverlayTrigger, Tooltip } from 'react-bootstrap';
import {  BsCircleHalf, BsMoonStars, BsPower, BsSearch, BsSun, BsPerson, BsCart, BsBookmarkCheck  } from 'react-icons/bs';
import { Link,  useNavigate } from 'react-router-dom';


const themeModes = [{
  icon: BsSun,
  theme: 'light'
}, {
  icon: BsMoonStars,
  theme: 'dark'
}, {
  icon: BsCircleHalf,
  theme: 'auto'
}];



const TopNavBar4 = () => {
  const { scrollY } = useScrollEvent();
  const { user, removeSession } = useAuthContext(); // <-- récupère user
  const { isOpen, toggle } = useToggle();
  const navigate = useNavigate();

  const { items, removeItem, updateItem, clearPanier, getTotal, getItemCount } = usePanier();// gestion de panier

  return (
    <header className={clsx('navbar-light header-sticky bg-dark', { 'header-sticky-on': scrollY >= 400 })}>
      <Navbar expand="xl">
        <Container>
          <LogoBox />

          {/* Toggle mobile */}
          <button
            onClick={toggle}
            className="navbar-toggler ms-auto mx-3 p-0 p-sm-2"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarCollapse"
            aria-controls="navbarCollapse"
            aria-expanded={isOpen}
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-animation">
              <span />
              <span />
              <span />
            </span>
          </button>

          <AppMenu mobileMenuOpen={isOpen} showExtraPages />

          <ul className="nav flex-row align-items-center list-unstyled ms-xl-auto">
            {/* Recherche */}
            
            <Dropdown className="nav-item ms-2 me-3 ms-md-3">
  <DropdownToggle className="nav-notification btn btn-light p-0 mb-0 flex-centered arrow-none">
    <BsCart />
  </DropdownToggle>

  <span className="notif-badge animation-blink" />

  <DropdownMenu align="end" className="dropdown-animation dropdown-menu-size-md shadow-lg p-0" renderOnMount>
    <Card className="bg-transparent">
      <CardHeader className="bg-transparent d-flex justify-content-between align-items-center border-bottom">
        <h6 className="m-0">
           <span className="badge bg-opacity-10 text-success ms-2">{getItemCount()} commandes</span>
        </h6>
        <button
  className="btn w-100 mb-0 bg-youtube"
  onClick={clearPanier}
>
  Vider le panier
</button>
      </CardHeader>

      <CardBody className="p-0" style={{ maxHeight: '300px', overflowY: 'auto' }}>
        <ListGroup className="list-group-flush list-unstyled p-2">
          {/* Exemple d’articles dans le panier */}
          
          {items.map((item) => (
          <ListGroupItem className="list-group-item-action rounded border-0 mb-1 p-3">
            <h6 className="mb-2">N° table : {item.tableNumber}</h6>
            <p className="mb-0 small">N° chaise: {item.chairNumber} - {item.price.toFixed(3)} TND</p>
          </ListGroupItem>
          ))}

          <ListGroupItem className="list-group-item-action rounded border-0 mb-1 p-3">
            
            <h6 className="mb-2 text-success text-center">TOTAL:{getTotal().toFixed(3)} TND</h6>
          </ListGroupItem>

        </ListGroup>
      </CardBody>

      <CardFooter className="bg-transparent text-center border-top">
        <button
  className="btn w-100 mb-0 bg-youtube"
  onClick={() => {
  navigate('/offer-detail');
  }}
>
  Valider la commande
</button>
      </CardFooter>
    </Card>
  </DropdownMenu>
</Dropdown>


            
<Dropdown className="nav-item" autoClose="outside">
  <DropdownToggle
    id="profileDropdown"
    className="p-0 border-0 bg-transparent"
  >
    <div
      style={{
        width: '40px',
        height: '40px',
        border: '#ddd',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        backgroundColor: '#f9f9f9',
        marginTop: '30px',
      }}
    >
      <BsPerson size={22} color="#555" />
    </div>
  </DropdownToggle>

  <DropdownMenu
    align="end"
    className="dropdown-animation dropdown-menu-end shadow pt-2"
  >
    {!user ? (
      // Si l'utilisateur n'est pas connecté → Se connecter
      
      <DropdownItem as={Link} to="/auth/sign-in">
        <BsPerson className="me-2" /> Se connecter
      </DropdownItem>

    ) : (
      // Si l'utilisateur est connecté (login ou signup)
      <>
        <DropdownItem disabled>
          {user.email} {/* Affiche l'email de l'utilisateur */}
        </DropdownItem>

        <DropdownDivider />
         <DropdownItem onClick={() => {
  navigate('/my-offer-list');
  }}>
         
              <BsBookmarkCheck className=" fa-fw me-2" />
                    Mes réservations
    </DropdownItem>
    <DropdownDivider />
        <DropdownItem
          onClick={removeSession} // Fonction pour déconnecter
          className="text-danger"
        >
          <BsPower className="me-2" /> Se déconnecter
        </DropdownItem>
      </>
    )}
  </DropdownMenu>
</Dropdown>






          </ul>
        </Container>
      </Navbar>
    </header>
  );
};

export default TopNavBar4;