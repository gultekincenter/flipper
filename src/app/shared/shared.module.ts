import { NgModule} from '@angular/core';
import { VendorsModule} from '@enexus/flipper-vendors';
import {PageNotFoundComponent} from './components/';
import {WebviewDirective} from './directives/';
import {FlipperEventModule} from '@enexus/flipper-event';
import {FlipperComponentsModule} from '@enexus/flipper-components';
import {FlipperPosModule} from '@enexus/flipper-pos';
import {FlipperMenuModule } from '@enexus/flipper-menu';
import { FlipperDashboardModule } from '@enexus/flipper-dashboard';
import { FlipperOfflineDatabaseModule } from '@enexus/flipper-offline-database';
import { FlipperSettingsModule } from '@enexus/flipper-settings';
import { FlipperInventoryModule } from '@enexus/flipper-inventory';
import { FlipperPaymentCardModule } from '@enexus/payment-card';
@NgModule({
  declarations: [
    PageNotFoundComponent,
    WebviewDirective
  ],
  imports: [
    FlipperEventModule,
    FlipperComponentsModule,
    FlipperPosModule,
    VendorsModule,
    FlipperMenuModule,
    FlipperDashboardModule,
    FlipperOfflineDatabaseModule,
    FlipperSettingsModule,
    FlipperInventoryModule,FlipperPaymentCardModule
  ],
  exports: [
    WebviewDirective,
    FlipperEventModule,
    FlipperComponentsModule,
    FlipperPosModule,
    VendorsModule,
    FlipperMenuModule,
    FlipperDashboardModule,
    FlipperOfflineDatabaseModule,
    FlipperSettingsModule,
    FlipperInventoryModule,
    FlipperPaymentCardModule
  ]
})
export class SharedModule {}