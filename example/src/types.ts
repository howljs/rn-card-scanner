import type { CardScannerResponse } from 'rn-card-scanner';

export interface RecognizerScreenParams {
  useAppleVision?: boolean;
}

export type RootStackRoutes = {
  Home: undefined;
  Recognizer: RecognizerScreenParams;
  Result?: CardScannerResponse;
};
