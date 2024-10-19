import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HistlibComponent } from './histlib.component';

describe('HistlibComponent', () => {
  let component: HistlibComponent;
  let fixture: ComponentFixture<HistlibComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [HistlibComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HistlibComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
