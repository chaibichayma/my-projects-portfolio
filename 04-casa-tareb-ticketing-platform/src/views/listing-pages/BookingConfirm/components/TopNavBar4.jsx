import { AppMenu, LogoBox } from '@/components';
import { useScrollEvent, useToggle } from '@/hooks';
import { useAuthContext, useLayoutContext } from '@/states';
import { toSentenceCase } from '@/utils';
import clsx from 'clsx';
import { Card, CardBody, CardFooter, CardHeader, Container, Dropdown, DropdownDivider, DropdownItem, DropdownMenu, DropdownToggle, ListGroup, ListGroupItem, Navbar, OverlayTrigger, Tooltip } from 'react-bootstrap';
import { BsBell, BsBookmarkCheck, BsCircleHalf, BsGear, BsHeart, BsInfoCircle, BsMoonStars, BsPower, BsSearch, BsSun, BsCart, BsPerson } from 'react-icons/bs';
import { Link , useNavigate} from 'react-router-dom';
import avatar1 from '@/assets/images/avatar/01.jpg';
import { notificationData } from '../data';
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
  const { removeSession, user } = useAuthContext(); // <-- récupérer l'utilisateur
  const { theme, updateTheme } = useLayoutContext();
  const { isOpen, toggle } = useToggle();
 
  const navigate = useNavigate();
  
  
  return <header className={clsx('navbar-light header-sticky', {
    'header-sticky-on': scrollY >= 400
  })}>
      <Navbar expand="xl">
        <Container>
          <LogoBox />
          <button onClick={toggle} className="navbar-toggler ms-auto mx-3 p-0 p-sm-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded={isOpen} aria-label="Toggle navigation">
            <span className="navbar-toggler-animation">
              <span />
              <span />
              <span />
            </span>
          </button>

          <AppMenu mobileMenuOpen={isOpen} showExtraPages />

          <ul className="nav flex-row align-items-center list-unstyled ms-xl-auto">
            <Dropdown className="nav-item nav-search d-none d-sm-block">
              <DropdownToggle as={Link} to="" className="arrow-none nav-notification btn btn-light mb-0 p-0">
                <BsSearch />
              </DropdownToggle>
              <DropdownMenu
  className="dropdown-animation dropdown-menu-end p-2"
  aria-labelledby="searchDropdown"
>
  <div className="nav flex-nowrap align-items-center">
    <div className="nav-item w-100">
      <form className="input-group">
        <input
          className="form-control"
          type="search"
          placeholder="Rechercher..."
          aria-label="Search"
        />
        <button
          className="btn m-0"
          type="submit"
          style={{
            backgroundColor: '#ffd700',
            borderColor: '#ffd700',
            color: '#000'
          }}
        >
          Rechercher
        </button>
      </form>
    </div>
  </div>
</DropdownMenu>
            </Dropdown>
            
            <Dropdown className="nav-item ms-2 me-3 ms-md-3">
  <DropdownToggle className="nav-notification btn btn-light p-0 mb-0 flex-centered arrow-none">
    <BsCart />
  </DropdownToggle>

  <span className="notif-badge animation-blink" />

  <DropdownMenu align="end" className="dropdown-animation dropdown-menu-size-md shadow-lg p-0" renderOnMount>
    <Card className="bg-transparent">
      <CardHeader className="bg-transparent d-flex justify-content-between align-items-center border-bottom">
        <h6 className="m-0">
          Panier <span className="badge bg-danger bg-opacity-10 text-danger ms-2">2 réservations</span>
        </h6>
        <Link className="small" to="">
          Vider le panier
        </Link>
      </CardHeader>

      <CardBody className="p-0">
        <ListGroup className="list-group-flush list-unstyled p-2">
          {/* Exemple d’articles dans le panier */}
          <ListGroupItem className="list-group-item-action rounded border-0 mb-1 p-3">
            <h6 className="mb-2">Numéro de table : 1</h6>
            <p className="mb-0 small">Nombre de chaises: 3 - 50 TND</p>
          </ListGroupItem>
          <ListGroupItem className="list-group-item-action rounded border-0 mb-1 p-3">
            <h6 className="mb-2">Numéro de table : 6</h6>
            <p className="mb-0 small">Nombre de chaises: 6 - 120 TND</p>
          </ListGroupItem>
        </ListGroup>
      </CardBody>

      <CardFooter className="bg-transparent text-center border-top">
        <button
  className="btn btn-sm btn-link mb-0 p-0"
  onClick={() => {
    if (user) {
      navigate('/evenement/payment');
    } else {
      navigate('/auth/sign-in');
    }
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
    className="avatar avatar-sm p-0 arrow-none mb-0 border-0 d-flex justify-content-center align-items-center"
    id="profileDropdown"
    role="button"
    style={{
      backgroundColor: '#f0f0f0', // fond gris clair
      borderRadius: '8px',        // coins légèrement arrondis
      width: '40px',
      height: '40px',
    }}
  >
    {user?.avatar ? (
      <img
        className="avatar-img rounded-2"
        src={user.avatar}
        alt="avatar"
        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
      />
    ) : (
      <BsPerson size={24} color="#000" />
    )}
  </DropdownToggle>

  <DropdownMenu
    align="end"
    className="dropdown-animation dropdown-menu-end shadow pt-3"
    aria-labelledby="profileDropdown"
    renderOnMount
  >
    {user ? (
      <>
        {/* Utilisateur connecté */}
        <li className="px-3 mb-3">
          <div className="d-flex align-items-center">
            <div
              style={{
                backgroundColor: '#f0f0f0',
                borderRadius: '8px',
                width: '40px',
                height: '40px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                overflow: 'hidden',
                marginRight: '12px'
              }}
            >
              {user.avatar ? (
                <img
                  className="avatar-img"
                  src={user.avatar}
                  alt="avatar"
                  style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                />
              ) : (
                <BsPerson size={24} color="#000" />
              )}
            </div>
            <div>
              <h6 className="h6 mt-2 mt-sm-0">{user.name}</h6>
              <p className="small m-0">{user.email}</p>
            </div>
          </div>
        </li>

        <DropdownDivider />

        <DropdownItem className="bg-danger-soft-hover" onClick={removeSession}>
          <BsPower className="fa-fw me-2" />
          Se déconnecter
        </DropdownItem>

        <DropdownDivider />
      </>
    ) : (
      <>
        {/* Utilisateur non connecté */}
        <DropdownItem as={Link} to="/auth/sign-in">
          <BsPerson className="me-2" /> Se connecter
        </DropdownItem>
      </>
    )}

    
  </DropdownMenu>
</Dropdown>
          </ul>
        </Container>
      </Navbar>
    </header>;
};
export default TopNavBar4;