import { PasswordFormInput, TextFormInput } from '@/components';
import { Col } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import useSignIn from './useSignIn';
import signInImg from '@/assets/images/element/jaune.jpg';
import logoIcon from '@/assets/images/logo-icon.svg';
import { developedByLink, currentYear } from '@/states';
const SignIn = () => {
  const {
    control,
    loading,
    login
  } = useSignIn();
  return <>
      
      
      <Col lg={6} className="d-flex align-items-center order-2 order-lg-1">
        <div className="p-3 p-lg-5">
          <img src={signInImg} />
        </div>

        <div className="vr opacity-1 d-none d-lg-block" />
      </Col>

      <Col lg={6} className="order-1">
        <div className="p-4 p-sm-7">
          <Link to="/">
            <img className="h-50px mb-4" src={logoIcon} alt="logo" />
          </Link>

          <h1 className="mb-2 h3">Content de te revoir</h1>
          <p className="mb-0">
            Nouveau ici?<Link to="/auth/sign-up"> Créer un compte</Link>
          </p>

          <form onSubmit={login} className="mt-4 text-start">
            <TextFormInput name="email" containerClass="mb-3" label="Entrez l'identifiant d'email" type="email" control={control} />

            <PasswordFormInput name="password" containerClass="mb-3" label="Entrez le mot de passe" control={control} />

            <div className="mb-3 d-sm-flex justify-content-between">
              <div className="d-flex gap-1">
                
                <label className="form-check-label" htmlFor="rememberCheck">
                  
                </label>
              </div>
              <Link to="/auth/forgot-password">
                Mot de passe oublié?</Link>
            </div>

            <div>
              <button
  type="submit"
  className="btn w-100 mb-0"
  disabled={loading}
  style={{ backgroundColor: '#FFD700', borderColor: '#FFD700', color: '#000' }}
>
  Se connecter
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
export default SignIn;