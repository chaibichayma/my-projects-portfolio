import { NavbarBrand } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import clsx from 'clsx';
import logoLightSvg from '@/assets/images/logo-light.svg';
import logoSvg from '@/assets/images/logo.svg';
const LogoBox = ({
  imgClassName,
  onlyDark
}) => {
  return <NavbarBrand as={Link} to="/">
      <img className={clsx(!onlyDark && 'light-mode-item', 'navbar-brand-item', imgClassName)} src={logoSvg} alt="logo" />
      {!onlyDark && <img className={clsx('dark-mode-item navbar-brand-item', imgClassName)} src={logoLightSvg} alt="logo" />}
    </NavbarBrand>;
};
export default LogoBox;