import { FormControl, FormGroup, FormLabel, FormText } from 'react-bootstrap';
import Feedback from 'react-bootstrap/esm/Feedback';
import { Controller } from 'react-hook-form';
const FileFormInput = ({
  name,
  containerClass,
  control,
  helpText,
  id,
  label,
  noValidate,
  ...other
}) => {
  return <Controller name={name} defaultValue={''} control={control} render={({
    field,
    fieldState
  }) => <FormGroup className={containerClass ?? ''}>
          {label && <FormLabel>{label}</FormLabel>}
          <FormControl type="file" id={id} {...other} {...field} isInvalid={Boolean(fieldState.error?.message)} />
          {helpText && typeof helpText === 'string' ? <FormText id={`${id}-help`}>{helpText}</FormText> : helpText}

          {!noValidate && fieldState.error?.message && <Feedback type="invalid">{fieldState.error?.message}</Feedback>}
        </FormGroup>} />;
};
export default FileFormInput;