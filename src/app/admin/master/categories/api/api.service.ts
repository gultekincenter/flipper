import { Injectable } from '@angular/core';
import { AppHttpClient } from '../../../../common/core/http/app-http-client.service';
import { Category } from './category';
import { BackendResponse } from '../../../../common/core/types/backend-response';
import { API_ROUTES } from './api-routes.enum';
import { Observable } from 'rxjs';
import { PaginationResponse } from '../../../../common/core/types/pagination-response';
export interface CategoryEntriesPaginationResponse extends PaginationResponse<Category> {
  category?: Category;
}
@Injectable({
    providedIn: 'root'
})
export class ApiCategoryService {
    constructor(private http: AppHttpClient) {}


    public create(params: Category): BackendResponse<{ data: any }> {
        return this.http.post(API_ROUTES.CATEGORY, params);
    }
    public get(): BackendResponse<{ categories: Category[] }> {
      return this.http.get(API_ROUTES.CATEGORY);
  }
  public getCategories(): Observable<CategoryEntriesPaginationResponse> {
    return this.http.get(API_ROUTES.CATEGORY);
}
}