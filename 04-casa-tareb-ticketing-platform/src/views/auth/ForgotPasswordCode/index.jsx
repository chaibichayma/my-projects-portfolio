import { TextFormInput } from '@/components';
import { yupResolver } from '@hookform/resolvers/yup';
import { Col } from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import { FaFacebookF } from 'react-icons/fa';
import { FcGoogle } from 'react-icons/fc';
import { Link, useNavigate } from 'react-router-dom';
import * as yup from 'yup';
import { useEffect, useMemo, useState } from 'react';
import forgotPassImg from '@/assets/images/element/jaune.jpg';
import logoIcon from '@/assets/images/logo-icon.svg';
import { developedByLink, currentYear } from '@/states';

const ForgotPasswordCode = () => {
  const [stepTwo, setStepTwo] = useState(false);
  const [timer, setTimer] = useState(240); // 4 minutes
  const navigate = useNavigate();



  // ✅ Schema dynamique
  const forgotPassFormSchema = useMemo(
    () =>
      yup.object({
        email: yup
          .string()
          .email('Please enter a valid email')
          .required('Please enter your email'),

        password: stepTwo
          ? yup
              .string()
              .min(6, 'Minimum 6 caractères')
              .required('Nouveau mot de passe requis')
          : yup.string().notRequired(),

        confirmPassword: stepTwo
          ? yup
              .string()
              .oneOf([yup.ref('password')], 'Les mots de passe ne correspondent pas')
              .required('Confirmation requise')
          : yup.string().notRequired(),

        code: stepTwo
          ? yup.string().required('Code requis')
          : yup.string().notRequired()
      }),
    [stepTwo]
  );

  // ✅ useForm correct
  const { control, handleSubmit } = useForm({
    resolver: yupResolver(forgotPassFormSchema)
  });

  const onSubmit = (data) => {
  if (!stepTwo) {
    // Envoyer le code par email
    setStepTwo(true);
    setTimer(240);
  } else {
    // Ici normalement tu appelles l’API pour confirmer le code
    console.log(data);

    // 🔁 Redirection vers login
    navigate('/auth/sign-in');
  }
};


  // ✅ Timer
  useEffect(() => {
    if (!stepTwo || timer === 0) return;

    const interval = setInterval(() => {
      setTimer((prev) => prev - 1);
    }, 1000);

    return () => clearInterval(interval);
  }, [stepTwo, timer]);

  return (
    <>
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
          <p className="mb-sm-0">
            Saisissez l'adresse e-mail associée à un compte.
          </p>

          <form onSubmit={handleSubmit(onSubmit)} className="mt-sm-4 text-start">
            <TextFormInput
              name="email"
              containerClass="mb-3"
              label="Entrez l'identifiant d'email"
              type="email"
              control={control}
            />

            {stepTwo && (
              <>
                <TextFormInput
                  name="password"
                  containerClass="mb-3"
                  label="Nouveau mot de passe"
                  type="password"
                  control={control}
                />

                <TextFormInput
                  name="confirmPassword"
                  containerClass="mb-3"
                  label="Confirmer nouveau mot de passe"
                  type="password"
                  control={control}
                />

                <TextFormInput
                  name="code"
                  containerClass="mb-2"
                  label="Code de vérification"
                  type="text"
                  control={control}
                />

                <div className="d-flex justify-content-between align-items-center mb-3">
                  <small className="text-muted">
                    Code expire dans {timer}s
                  </small>

                  <button
                    type="button"
                    className="btn btn-link p-0"
                    onClick={() => setTimer(240)}
                  >
                    Renvoyer le code
                  </button>

                </div>
              </>
            )}

            <div className="d-grid">
              <button
                type="submit"
                className="btn"
                style={{
                  backgroundColor: '#FFD700',
                  borderColor: '#FFD700',
                  color: '#000'
                }}
              >
                {stepTwo ? 'Confirmer' : 'Réinitialiser le mot de passe'}
              </button>

            </div>

            <div className="text-primary-hover text-body mt-3 text-center">
              ©{currentYear} – Réalisé par{' '}
              <a href={developedByLink} target="_blank" className="text-body">
                BlastiNet
              </a>
            </div>
          </form>
        </div>
      </Col>
    </>
  );
};

export default ForgotPasswordCode;
