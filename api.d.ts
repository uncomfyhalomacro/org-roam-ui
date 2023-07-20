export type OrgRoamGraphReponse = {
  nodes: OrgRoamNode[]
  links: OrgRoamLink[]
  tags: string[] | null
}

export type OrgRoamNode = {
  id: string
  file: string
  title: string
  level: number
  pos: number
  olp: string[] | null
  properties: {
    [key: string]: string | number | boolean | undefined
  }
  tags: any[]
}

export type OrgRoamLink = {
  source: string
  target: string
  type: string
}
