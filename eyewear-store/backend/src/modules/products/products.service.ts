import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { FilterProductDto } from './dto/filter-product.dto';
import { BrandsService } from '../brands/brands.service';
import { CategoriesService } from '../categories/categories.service';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly brandsService: BrandsService,
    private readonly categoriesService: CategoriesService,
  ) {}

  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { brandId, categoryIds, ...productDetails } = createProductDto;
    
    const product = this.productRepository.create(productDetails);
    
    if (brandId) {
      const brand = await this.brandsService.findOne(brandId);
      product.brand = brand;
    }
    
    if (categoryIds && categoryIds.length > 0) {
      const categories = await this.categoriesService.findByIds(categoryIds);
      product.categories = categories;
    }
    
    return this.productRepository.save(product);
  }

  async findAll(filterDto: FilterProductDto): Promise<Product[]> {
    const { category, brand, minPrice, maxPrice, gender, search, sortBy, sortOrder } = filterDto;
    
    const queryBuilder = this.productRepository.createQueryBuilder('product')
      .leftJoinAndSelect('product.brand', 'brand')
      .leftJoinAndSelect('product.categories', 'category')
      .leftJoinAndSelect('product.images', 'image')
      .where('product.isActive = :isActive', { isActive: true });
    
    if (category) {
      queryBuilder.andWhere('category.slug = :category', { category });
    }
    
    if (brand) {
      queryBuilder.andWhere('brand.slug = :brand', { brand });
    }
    
    if (minPrice !== undefined) {
      queryBuilder.andWhere('product.price >= :minPrice', { minPrice });
    }
    
    if (maxPrice !== undefined) {
      queryBuilder.andWhere('product.price <= :maxPrice', { maxPrice });
    }
    
    if (gender) {
      queryBuilder.andWhere('product.gender = :gender', { gender });
    }
    
    if (search) {
      queryBuilder.andWhere('(product.name ILIKE :search OR product.description ILIKE :search)', 
        { search: `%${search}%` });
    }
    
    if (sortBy) {
      const order = sortOrder === 'DESC' ? 'DESC' : 'ASC';
      queryBuilder.orderBy(`product.${sortBy}`, order);
    } else {
      queryBuilder.orderBy('product.createdAt', 'DESC');
    }
    
    return queryBuilder.getMany();
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: ['brand', 'categories', 'images'],
    });
    
    if (!product) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
    
    return product;
  }

  async update(id: string, updateProductDto: UpdateProductDto): Promise<Product> {
    const { brandId, categoryIds, ...updateData } = updateProductDto;
    
    const product = await this.findOne(id);
    
    if (brandId) {
      const brand = await this.brandsService.findOne(brandId);
      product.brand = brand;
    }
    
    if (categoryIds) {
      const categories = await this.categoriesService.findByIds(categoryIds);
      product.categories = categories;
    }
    
    Object.assign(product, updateData);
    
    return this.productRepository.save(product);
  }

  async remove(id: string): Promise<void> {
    const result = await this.productRepository.delete(id);
    
    if (result.affected === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
  }
}
