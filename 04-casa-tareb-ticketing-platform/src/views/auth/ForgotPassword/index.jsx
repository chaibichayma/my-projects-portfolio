import { TextFormInput } from '@/components';
import { yupResolver } from '@hookform/resolvers/yup';
import { Col } from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import { FaFacebookF } from 'react-icons/fa';
import { FcGoogle } from 'react-icons/fc';
import { Link,  useNavigate } from 'react-router-dom';
import * as yup from 'yup';
import forgotPassImg from '@/assets/images/element/jaune.jpg';
import logoIcon from '@/assets/images/logo-icon.svg';
import { developedByLink, currentYear } from '@/states';
const ForgotPassword = () => {
  const forgotPassFormSchema = yup.object({
    email: yup.string().email('Please enter a valid email').required('Veuillez saisir une adresse e-mail valide')
  });
  const {
    control,
    handleSubmit
  } = useForm({
    resolver: yupResolver(forgotPassFormSchema)
  });
  const navigate = useNavigate();
  return <>
      <Col lg={6} className="d-md-flex align-items-center order-2 order-lg-1">
        <div className="p-3 p-lg-5">
          <img src={forgotPassImg} />
        </div>

        <div className="vr opacity-1 d-none d-lg-block" />
      </Col>

      <Col lg={6} className="order-1">
        <div className="p-4 p-sm-7">
          <Link to="/">
            <img className="mb-4 h-50px" src={logoIcon} alt="logo" />
          </Link>

          <h1 className="mb-2 h3">Mot de passe oublié ?</h1>
          <p className="mb-sm-0">Saisissez l'adresse e-mail associée à un compte.</p>

          <form onSubmit={handleSubmit(() => {})} className="mt-sm-4 text-start">
            <TextFormInput name="email" containerClass="mb-3" label="Entrez l'identifiant d'email" type="email" control={control} />

            <div className="mb-3 text-center">
              <p>
                Retour à <Link to="/auth/sign-in">Se connecter</Link>
              </p>
            </div>

            <div className="d-grid">
              <button
  type="submit"
  className="btn"
  style={{ backgroundColor: '#FFD700', borderColor: '#FFD700', color: '#000' }}
  onClick={() => {
  navigate('/auth/forgot-password-code');
  }}
>
  Réinitialiser le mot de passe
</button>

            </div>

            

            

            <div className="text-primary-hover text-body mt-3 text-center">
              {' '}
              Droits d'auteur ©{currentYear} . Réalisé par{' '}
              <a href={developedByLink} target="_blank" className="text-body">
                BlastiNet
              </a>
              .{' '}
            </div>
          </form>
        </div>
      </Col>
    </>;
};
export default ForgotPassword;