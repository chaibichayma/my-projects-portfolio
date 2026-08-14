import { PasswordFormInput, TextFormInput } from '@/components';
import { Col } from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import { Link } from 'react-router-dom';
import signInImg from '@/assets/images/element/jaune.jpg';
import logoIcon from '@/assets/images/logo-icon.svg';
import { useNavigate } from "react-router-dom";
import { developedByLink, currentYear } from '@/states';
import { useAuthContext, useNotificationContext } from '@/states';
import { yupResolver } from '@hookform/resolvers/yup';

import * as yup from 'yup';
import { URL_API_NAME } from '../../../states/constants';
const SignUp = () => {
  const navigate = useNavigate();
   const {
    showNotification
  } = useNotificationContext();

  const loginFormSchema = yup.object({
      email: yup.string().email('Veuillez saisir une adresse e-mail valide').required('Veuillez saisir une adresse e-mail valide'),
      password: yup.string().required('Veuillez entrer votre mot de passe'),
      username: yup.string().required('Veuillez entrer votre nom')
    });

  const { control, handleSubmit } = useForm({
      resolver: yupResolver(loginFormSchema),
      defaultValues: {
        email: '',
        password: ''
      }
    });
  const { saveSession } = useAuthContext(); // <-- récupère user

  

 
const saveUserData = async (userData) => {
  try {
     await fetch(URL_API_NAME+'/events/saveEventUser', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
           "Access-Control-Allow-Origin": true
        },
        body: '{"username":"'+userData.name+'","email":"'+userData.email+'","password":"'+userData.password+'"}',
        
      }).then((res) => res.json())
    .then((data) => {
      if(data &&  data.isValid){
      saveSession(userData);
      navigate('/'); 
      }else{
        showNotification({
          message: 'E-mail déjà utilisé',
          type: 'error'
        });
      }
  
    })
    
  } catch (error) {
  console.log("URL appelée :", error.config.url);
  console.log("Base URL :", error.config.baseURL);
  console.error('Error saving user:', error.message);
    throw new Error(error.message);
  }
};




  return <>
      <Col lg={6} className="d-md-flex align-items-center order-2 order-lg-1">
        <div className="p-3 p-lg-5">
          <img src={signInImg} />
        </div>

        <div className="vr opacity-1 d-none d-lg-block" />
      </Col>

      <Col lg={6} className="order-1">
        <div className="p-4 p-sm-6">
          <Link to="/">
            <img className="h-50px mb-4" src={logoIcon} alt="logo" />
          </Link>

          <h1 className="mb-2 h3">Créer un nouveau compte</h1>
          <p className="mb-0">
           Déjà membre?<Link to="/auth/sign-in"> 
            Se connecter</Link>
          </p>

          <form onSubmit={handleSubmit(saveUserData)} className="mt-4 text-start">

            <TextFormInput name="username"  containerClass="mb-3" label="Entrez le nom" control={control} />
            <TextFormInput name="email"   containerClass="mb-3"  label="Entrez l'identifiant d'email" type="email" control={control} />
            <PasswordFormInput name="password"  containerClass="mb-3" label="Entrez le mot de passe" control={control} />

            

           

            <div>
              <button
  type="submit"
  className="btn w-100 mb-0"
  style={{ backgroundColor: '#FFD700', borderColor: '#FFD700', color: '#000' }}
>
  S'inscrire
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
export default SignUp;