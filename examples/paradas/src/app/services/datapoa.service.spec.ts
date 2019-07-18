import { TestBed } from '@angular/core/testing';

import { DatapoaService } from './datapoa.service';

describe('DatapoaService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: DatapoaService = TestBed.get(DatapoaService);
    expect(service).toBeTruthy();
  });
});
