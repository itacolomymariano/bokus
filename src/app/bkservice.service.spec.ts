import { TestBed } from '@angular/core/testing';

import { BkserviceService } from './bkservice.service';

describe('BkserviceService', () => {
  let service: BkserviceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BkserviceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
