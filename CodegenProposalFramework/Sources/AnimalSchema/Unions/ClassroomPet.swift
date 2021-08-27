import CodegenProposalFramework

public enum ClassroomPet: UnionType {
  case Cat(Cat)
  case Bird(Bird)
  case Rat(Rat)
  case PetRock(PetRock)

  public init?(_ entity: CacheEntity) {
    switch entity {
    case let ent as Cat: self = .Cat(ent)
    case let ent as Bird: self = .Bird(ent)
    case let ent as Rat: self = .Rat(ent)
    case let ent as PetRock: self = .PetRock(ent)
    default: return nil
    }
  }

  public var entity: CacheEntity {
    switch self {
    case let .Cat(entity as CacheEntity),
         let .Bird(entity as CacheEntity),
         let .Rat(entity as CacheEntity),
         let .PetRock(entity as CacheEntity):
      return entity
    }
  }
}
